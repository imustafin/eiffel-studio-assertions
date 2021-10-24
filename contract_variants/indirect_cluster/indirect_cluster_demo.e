class
	INDIRECT_CLUSTER_DEMO

create
	make

feature

	make (satisfy: HASH_TABLE [BOOLEAN, STRING])
		require
			indirect_cluster_pre_: satisfy ["indirect_cluster_pre_"]
		do
			check
				indirect_cluster_check_: satisfy ["indirect_cluster_check_"]
			end
		end

end
