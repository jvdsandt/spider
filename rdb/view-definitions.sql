
CREATE OR REPLACE VIEW v_mc_package_roots AS (
	WITH RECURSIVE all_children AS (
		SELECT mp.id as id, mp.id as root_id 
            FROM mc_packages mp 
            WHERE not exists (select * from mc_package_ancestors where mc_package_id = id)
		UNION
		SELECT mpa.mc_package_id AS id, a.root_id 
            FROM mc_package_ancestors mpa JOIN all_children a ON a.id = mpa.mc_ancestor_id
	) SELECT * FROM all_children
);
GRANT SELECT ON TABLE v_mc_package_roots TO spreader;

CREATE OR REPLACE VIEW v_git_commit_roots AS (
	WITH RECURSIVE all_children AS (
		SELECT gc.id as id, gc.id as root_id
            FROM git_commits gc 
            WHERE not exists (select * from git_commit_parent_refs where commit_id = id)
		UNION
		SELECT gcpr.commit_id AS id, a.root_id
            FROM git_commit_parent_refs gcpr JOIN all_children a ON a.id = gcpr.parent_id
	) SELECT * FROM all_children
);
GRANT SELECT ON TABLE v_git_commit_roots TO spreader;
