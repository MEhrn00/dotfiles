#!/usr/bin/env python3
# Ansible vault client script for retrieving an Ansible vault password via Bitwarden
# Secrets Manager.
#
# This script will grab the Bitwarden Secrets Manager access token via libsecret.
#
# Config options
# [vault_bws]
# organization_id = a64ef692-453f-4a96-a1f9-46a871645d48
# project = bws-project
# account = Machine

import argparse
import sys

import gi
from ansible.config.manager import ConfigManager
from bitwarden_sdk import BitwardenClient

gi.require_version("Secret", "1")
from gi.repository import Secret

BWS_TOKEN_SECRET_SCHEMA = Secret.Schema.new(
    "org.freedesktop.Secret.Generic",
    Secret.SchemaFlags.NONE,
    {
        "account": Secret.SchemaAttributeType.STRING,
        "key": Secret.SchemaAttributeType.STRING,
        "service": Secret.SchemaAttributeType.STRING,
    },
)

VAULT_BWS_PLUGIN_DEFS = {
    "VAULT_BWS_PROJECT": {
        "description": "Name of the BWS project to get the vault password from.",
        "name": "Vault BWS project name.",
        "env": [
            {
                "name": "VAULT_BWS_PROJECT",
            }
        ],
        "ini": [
            {
                "section": "vault_bws",
                "key": "project",
            }
        ],
        "type": "str",
    },
    "VAULT_BWS_ACCOUNT": {
        "description": "Account attribute in the secret store with the BWS access token.",
        "name": "BWS account attribute.",
        "env": [
            {
                "name": "VAULT_BWS_ACCOUNT",
            }
        ],
        "ini": [
            {
                "section": "vault_bws",
                "key": "account",
            }
        ],
        "type": "str",
    },
    "VAULT_BWS_ORGANIZATION_ID": {
        "description": "UUID of the BWS organization to get the secret from.",
        "name": "Vault BWS organization id.",
        "env": [
            {
                "name": "VAULT_BWS_ORANIZATION_ID",
            }
        ],
        "ini": [
            {
                "section": "vault_bws",
                "key": "organization_id",
            }
        ],
        "type": "str",
    },
}


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Get a vault password via Bitwarden Secrets Manager"
    )

    parser.add_argument(
        "--vault-id",
        action="store",
        default=None,
        dest="vault_id",
        help="Ansible vault ID to lookup.",
    )

    parser.add_argument(
        "--project",
        action="store",
        default=None,
        dest="project",
        help="Name of the BWS project to lookup the secret in.",
    )

    parser.add_argument(
        "--account",
        action="store",
        default=None,
        dest="account",
        help="Name of the account associated with the BWS access token.",
    )

    parser.add_argument(
        "--organization-id",
        action="store",
        default=None,
        dest="organization_id",
        help="UUID of the BWS organization to get the secret from.",
    )

    return parser.parse_args()


def parse_ansible_config():
    config = ConfigManager()
    config.initialize_plugin_configuration_definitions(
        "vault", "bws", VAULT_BWS_PLUGIN_DEFS
    )

    return config.get_plugin_options("vault", "bws")


def lookup_bws_project(client, organization_id, project_name):
    projects = client.projects()
    projects_response = projects.list(organization_id)

    if not projects_response.success:
        raise RuntimeError(
            f"Failed to list projects: {projects_response.error_message}"
        )

    for project in projects_response.data.data:
        if project.name == project_name:
            return project.id


def list_bws_secrets(client, organization_id, secret_name):
    secrets = client.secrets()
    secrets_response = secrets.list(organization_id)

    if not secrets_response.success:
        raise RuntimeError(f"Failed to list secrets: {secrets_response.error_message}")

    return [
        secret.id for secret in secrets_response.data.data if secret.key == secret_name
    ]


def get_bws_secret(client, secret_id):
    secrets = client.secrets()
    secrets_response = secrets.get(secret_id)

    if not secrets_response.success:
        raise RuntimeError(f"Failed to get secret: {secrets_response.error_message}")

    return secrets_response


def lookup_token(account):
    token = Secret.password_lookup_sync(
        BWS_TOKEN_SECRET_SCHEMA,
        {
            "account": account,
            "key": "accesstoken",
            "service": "bws",
        },
        None,
    )

    if not token:
        raise RuntimeError(
            f"Could not find token associated with account '{account}' in secret store."
        )

    return token


def main():
    args = parse_arguments()
    ansible_config = parse_ansible_config()

    options = {
        "vault_id": args.vault_id,
        "project": args.project or ansible_config.get("VAULT_BWS_PROJECT") or None,
        "account": args.account or ansible_config.get("VAULT_BWS_ACCOUNT") or None,
        "organization_id": args.organization_id
        or ansible_config.get("VAULT_BWS_ORGANIZATION_ID")
        or None,
    }

    for k, v in options.items():
        if not v:
            options[k] = input(f"Vault BWS {k}: ")

    bws_token = lookup_token(options["account"])

    client = BitwardenClient()
    client.access_token_login(bws_token)

    project_id = lookup_bws_project(
        client, options["organization_id"], options["project"]
    )

    secret_ids = list_bws_secrets(
        client, options["organization_id"], options["vault_id"]
    )

    for secret_id in secret_ids:
        secret_data = get_bws_secret(client, secret_id)
        if not secret_data.success:
            continue

        if secret_data.data.project_id == project_id:
            print(secret_data.data.value)
            sys.exit(0)

    print(
        "Could not find secret for vault_id '{}' in project '{}'".format(
            options["vault_id"], options["project"]
        ),
        file=sys.stderr,
    )
    sys.exit(1)


if __name__ == "__main__":
    main()
