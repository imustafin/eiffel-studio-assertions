class
	OTHER_LIBRARY_DEMO

create
	make

feature

	make (satisfy: HASH_TABLE [BOOLEAN, STRING])
		require
			other_library_pre_: satisfy ["other_library_pre_"]
		do
			check
				other_library_check_: satisfy ["other_library_check_"]
			end
		end

end
