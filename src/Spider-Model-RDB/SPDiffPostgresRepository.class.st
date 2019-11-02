Class {
	#name : #SPDiffPostgresRepository,
	#superclass : #SPDiffRDBRepository,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPDiffPostgresRepository class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS diff_git_packages (
	commit_id INTEGER NOT NULL REFERENCES git_commits ON DELETE CASCADE,
	old_package_id INTEGER REFERENCES packages,
	new_package_id INTEGER REFERENCES packages
);
CREATE INDEX IF NOT EXISTS diff_git_packages_commit_idx ON diff_git_packages(commit_id);
CREATE INDEX IF NOT EXISTS diff_git_packages_old_idx ON diff_git_packages(old_package_id);
CREATE INDEX IF NOT EXISTS diff_git_packages_new_idx ON diff_git_packages(new_package_id);

CREATE TABLE IF NOT EXISTS diff_git_classes (
	commit_id INTEGER NOT NULL REFERENCES git_commits ON DELETE CASCADE,
	old_class_id INTEGER REFERENCES classes,
	new_class_id INTEGER REFERENCES classes
);
CREATE INDEX IF NOT EXISTS diff_git_classes_commit_idx ON diff_git_classes(commit_id);
CREATE INDEX IF NOT EXISTS diff_git_classes_old_idx ON diff_git_classes(old_class_id);
CREATE INDEX IF NOT EXISTS diff_git_classes_new_idx ON diff_git_classes(new_class_id);

CREATE TABLE IF NOT EXISTS diff_git_methods (
	commit_id INTEGER NOT NULL REFERENCES git_commits ON DELETE CASCADE,
	class_name VARCHAR NOT NULL,
	meta BOOLEAN NOT NULL,
	old_method_id INTEGER REFERENCES methods,
	new_method_id INTEGER REFERENCES methods
);
CREATE INDEX IF NOT EXISTS diff_git_methods_commit_idx ON diff_git_methods(commit_id);
CREATE INDEX IF NOT EXISTS diff_git_methods_old_idx ON diff_git_methods(old_method_id);
CREATE INDEX IF NOT EXISTS diff_git_methods_new_idx ON diff_git_methods(new_method_id);
'
]

{ #category : #initialization }
SPDiffPostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #initialization }
SPDiffPostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
