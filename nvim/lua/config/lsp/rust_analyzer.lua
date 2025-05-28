return {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
			lens = {
				enable = true,
			},
			semanticHighlighting = {
				operator = {
					enable = true,
					specialization = {
						enable = true,
					},
				},
				punctuation = {
					enable = true,
					separate = {
						macro = {
							bang = true,
						},
					},
					specialization = {
						enable = true,
					},
				},
			},
			completion = {
				fullFunctionSignatures = {
					enable = true,
				},
			},
		},
	},
}
