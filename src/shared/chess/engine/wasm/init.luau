--!strict

local WASM = {}

local messageListener: (string) -> ...any? = print

local rust
rust = require(script:WaitForChild("compiled"))({
	env = {
		time = { os.clock },
		print_string = {
			function(_, pointer, length)
				messageListener(buffer.readstring(rust.memory[1], pointer, length))
			end,
		},
	},
})

function WASM.sendInput(input)
	for i = 1, #input do
		local character = string.byte(input, i, i)
		rust.send_input[1](rust.send_input, character)
	end
	rust.send_input[1](rust.send_input, string.byte("\n"))
end

function WASM.setListener(newMessageListener)
	messageListener = newMessageListener
end

return table.freeze(WASM)
