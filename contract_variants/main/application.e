class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			run_demo (create {HASH_TABLE [BOOLEAN, STRING]}.make (0))
		end

	run_demo (satisfy: HASH_TABLE [BOOLEAN, STRING])
		local
			demo: DEMO
		do
			create demo.make (satisfy)
		rescue
			check attached {EXCEPTIONS}.tag_name as tag then
				print (tag + "%N")
				satisfy [tag] := True
				retry
			end
		end

end
