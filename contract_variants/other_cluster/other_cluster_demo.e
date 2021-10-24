class
	OTHER_CLUSTER_DEMO

create
	make

feature

	make (satisfy: HASH_TABLE [BOOLEAN, STRING])
		require
			other_cluster_pre_: satisfy ["other_cluster_pre_"]
		local
			indirect_cluster_demo: INDIRECT_CLUSTER_DEMO
		do
			check
				other_cluster_check_: satisfy ["other_cluster_check_"]
			end
			create indirect_cluster_demo.make (satisfy)
		end

end
