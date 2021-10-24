class
	SUBCLUSTER_DEMO

create
	make

feature

	make (satisfy: HASH_TABLE [BOOLEAN, STRING])
		require
			subcluster_require_: satisfy ["subcluster_require_"]
		do
			check
				subcluster_check_: satisfy ["subcluster_check_"]
			end
		end

end
