
-- All commits 
select gc.*
FROM
	git_repo_refs grr,
	v_git_commit_roots vgcr,
	git_commits gc
WHERE
	grr.repo_id = 3 AND grr.name = 'refs/heads/master' AND
	vgcr.id = grr.commit_id AND
	gc.id IN (SELECT id from v_git_commit_roots WHERE root_id = vgcr.root_id)
ORDER BY
	gc.author_datetime desc, gc.txid desc;
