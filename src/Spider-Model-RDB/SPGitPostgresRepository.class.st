Class {
	#name : #SPGitPostgresRepository,
	#superclass : #SPGitRDBRepository,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPGitPostgresRepository class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS git_repos (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	url VARCHAR NOT NULL,
	forked_from INTEGER REFERENCES git_repos(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS git_repo_url_idx ON git_repos(lower(url));
CREATE UNIQUE INDEX IF NOT EXISTS git_repo_forked_from_idx ON git_repos(forked_from);

CREATE TABLE IF NOT EXISTS git_commit_roots (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	root_shas VARCHAR[]
);

CREATE TABLE IF NOT EXISTS git_commits (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	sha VARCHAR(40) NOT NULL,
	author_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
	author_tzoffset INTEGER NOT NULL,
	author_name VARCHAR NOT NULL,
	author_email VARCHAR NOT NULL,
	message VARCHAR NOT NULL,
	status VARCHAR NOT NULL,
	root_id INTEGER REFERENCES git_commit_roots(id),
	source_dir VARCHAR,
	format VARCHAR
);
CREATE INDEX IF NOT EXISTS git_commit_sha_idx ON git_commits(sha);
CREATE INDEX IF NOT EXISTS git_commit_author_name_idx ON git_commits(lower(author_name));
CREATE INDEX IF NOT EXISTS git_commit_author_email_idx ON git_commits(lower(author_email));
CREATE INDEX IF NOT EXISTS git_commit_root_idx ON git_commits(root_id);

CREATE TABLE IF NOT EXISTS git_commit_pack_refs (
	commit_id INT NOT NULL REFERENCES git_commits(id),
	package_id INT NOT NULL REFERENCES packages(id),
	PRIMARY KEY (commit_id, package_id)
);
CREATE INDEX IF NOT EXISTS git_commit_pack_idx ON git_commit_pack_refs(package_id);

CREATE TABLE IF NOT EXISTS git_commit_parent_refs (
	commit_id INT NOT NULL REFERENCES git_commits(id),
	parent_id INT NOT NULL REFERENCES git_commits(id),
	seqnr INT NOT NULL,
	PRIMARY KEY (commit_id, parent_id)
);
CREATE INDEX IF NOT EXISTS git_commit_parent_idx ON git_commit_parent_refs(parent_id);

CREATE TABLE IF NOT EXISTS git_repo_refs (
	repo_id INT NOT NULL REFERENCES git_repos(id),
	type VARCHAR(1) NOT NULL,
	name VARCHAR NOT NULL,
	txid INTEGER NOT NULL,
	commit_id INT NOT NULL REFERENCES git_commits(id),
	PRIMARY KEY (repo_id, type, name)
);
CREATE INDEX IF NOT EXISTS git_repo_ref_commit_idx ON git_repo_refs(commit_id);
'
]

{ #category : #initialization }
SPGitPostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #initialization }
SPGitPostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
