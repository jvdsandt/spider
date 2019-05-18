Class {
	#name : #SPGlorpMonticelloClassDiff,
	#superclass : #SPGlorp,
	#instVars : [
		'fromPackage',
		'toPackage',
		'oldClass',
		'newClass'
	],
	#category : #'Spider-Model-MC'
}

{ #category : #resources }
SPGlorpMonticelloClassDiff class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS mc_class_diffs (
	from_package_id int,
	to_package_id int NOT NULL,
	old_class_id int,
	new_class_id int
);
CREATE INDEX IF NOT EXISTS mc_class_diffs_to_idx ON mc_class_diffs(to_package_id);
CREATE INDEX IF NOT EXISTS mc_class_diffs_new_idx ON mc_class_diffs(new_class_id);
'
]

{ #category : #'instance creation' }
SPGlorpMonticelloClassDiff class >> from: ancestorPackage to: package old: oldClassVersion new: newClassVersion [

	^ self new initFrom: ancestorPackage to: package old: oldClassVersion new: newClassVersion
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> fromPackage [
	^ fromPackage
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> fromPackageId [
	^ fromPackage ifNotNil: [ :p | p id ]
]

{ #category : #initialization }
SPGlorpMonticelloClassDiff >> initFrom: ancestorPackage to: package old: oldClassVersion new: newClassVersion [

	fromPackage := ancestorPackage.
	toPackage := package.
	oldClass := oldClassVersion.
	newClass := newClassVersion
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> newClass [
	^ newClass
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> newClassId [
	^ newClass ifNotNil: [ :c | c id ]
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> oldClass [
	^ oldClass
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> oldClassId [
	^ oldClass ifNotNil: [ :c | c id ]
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> toPackage [
	^ toPackage
]

{ #category : #accessing }
SPGlorpMonticelloClassDiff >> toPackageId [
	^ toPackage ifNotNil: [ :p | p id ]
]
