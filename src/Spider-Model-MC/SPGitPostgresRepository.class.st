Class {
	#name : #SPGitPostgresRepository,
	#superclass : #SPGitRDBRepository,
	#category : #'Spider-Model-MC-Repos'
}

{ #category : #resources }
SPGitPostgresRepository class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS git_repos (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	root_id INTEGER NOT NULL REFERENCES git_repos(id),
	url VARCHAR NOT NULL,
	forked_from_id INT REFERENCES git_repos(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS git_repo_url_idx ON git_repos(lower(url));
CREATE INDEX IF NOT EXISTS git_repo_root_idx ON git_repos(root_id);
CREATE INDEX IF NOT EXISTS git_repo_forked_idx ON git_repos(forked_from_id);

CREATE TABLE IF NOT EXISTS git_commits (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	repo_root_id INTEGER NOT NULL REFERENCES git_repos(id),
	sha BYTEA NOT NULL,
	datetime TIMESTAMP WITH TIME ZONE NOT NULL,
	author_name VARCHAR NOT NULL,
	auther_email VARCHAR NOT NULL,
	message VARCHAR NOT NULL,
);
CREATE INDEX IF NOT EXISTS git_commit_author_name_idx ON git_commits(lower(author_name));
CREATE INDEX IF NOT EXISTS git_commit_author_email_idx ON git_commits(lower(author_email));
CREATE INDEX IF NOT EXISTS git_commit_repo_idx ON git_commits(repo_root_id, datetime DESC);

CREATE IF NOT EXISTS git_commit_pack_refs (
	commit_id INT NOT NULL REFERENCES git_commits(id),
	package_id INT NOT NULL REFERENCES package(id),
	PRIMARY KEY (commit_id, package_id)
);
CREATE INDEX IF NOT EXISTS git_commit_pack_idx ON git_commit_pack_refs(package_id);

CREATE IF NOT EXISTS git_commit_parent_refs (
	commit_id INT NOT NULL REFERENCES git_commits(id),
	parent_id INT NOT NULL REFERENCES git_commits(id),
	seq_nr INT NOT NULL,
	PRIMARY KEY (commit_id, parent_id)
);
CREATE INDEX IF NOT EXISTS git_commit_parent_idx ON git_commit_parent_refs(parent_id);

CREATE TABLE IF NOT EXISTS git_refs (
	repo_id INT NOT NULL REFERENCES git_repos(id),
	name VARCHAR NOT NULL,
	commit_id INT NOT NULL REFERENCES git_commits(id),
	PRIMARY KEY (repo_id, name)
);
CREATE INDEX IF NOT EXISTS git_ref_commit_idx ON git_refs(commit_id);
'
]
