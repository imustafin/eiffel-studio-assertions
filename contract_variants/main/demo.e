class
	DEMO

create
	make

feature

	make (satisfy: HASH_TABLE [BOOLEAN, STRING])
		require
			require_: satisfy ["require_"]
		local
			i: INTEGER
			other_cluster_demo: OTHER_CLUSTER_DEMO
			other_library_demo: OTHER_LIBRARY_DEMO
			subcluster_demo: SUBCLUSTER_DEMO
		do
			check
				check_: satisfy ["check_"]
			end
			from
				i := 5
			invariant
				loop_invariant_: satisfy ["loop_invariant_"]
			until
				i = 0 or i = 10
			loop
				if satisfy ["loop_variant_"] then
					i := i - 1
				else
					i := i + 1
				end
			variant
				loop_variant_: i
			end
			satisfy_invariant := satisfy ["invariant_"]
			create other_cluster_demo.make (satisfy)
			create other_library_demo.make (satisfy)
			create subcluster_demo.make (satisfy)
		ensure
			ensure_: satisfy ["ensure_"]
		end

	satisfy_invariant: BOOLEAN

invariant
	invariant_: satisfy_invariant

end
