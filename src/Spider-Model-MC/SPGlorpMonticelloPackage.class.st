Class {
	#name : #SPGlorpMonticelloPackage,
	#superclass : #SPGlorpNode,
	#instVars : [
		'name',
		'mcId',
		'version',
		'branch',
		'author',
		'datetime',
		'message',
		'package',
		'ancestors',
		'rootId'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #'instance creation' }
SPGlorpMonticelloPackage class >> name: aName mcId: aMcId version: mcVersion branch: aBranch author: mcAuthor datetime: aTimestamp message: aMessage package: aPackeOrNil ancestors: anAncestorColl [

	^ self new initWithName: aName 
			mcId: aMcId 
			version: mcVersion 
			branch: aBranch 
			author: mcAuthor 
			datetime: aTimestamp 
			message: aMessage 
			package: aPackeOrNil 
			ancestors: anAncestorColl
]

{ #category : #comparing }
SPGlorpMonticelloPackage >> <= other [

	^ datetime <= other datetime
]

{ #category : #comparing }
SPGlorpMonticelloPackage >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ name = other name and: [ self mcId = other mcId ]
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> ancestors [
	^ ancestors
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> author [
	^ author
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> branch [
	^ branch
]

{ #category : #actions }
SPGlorpMonticelloPackage >> createClassDiffRecords [

	| records |

	self package isNil
		ifTrue: [ ^ #() ].
	
	records := OrderedCollection new.

	self ancestors do: [ :each |
		each package notNil
			ifTrue: [ 
				| diffs |
				diffs := self package createClassDiffsWith: each package.
				records addAll: (diffs collect: [ :eachAssoc |
					SPGlorpMonticelloClassDiff 
						from: each to: self 
						old: (eachAssoc key ifNotNil: [ :ref | ref spiderClass ])
						new: (eachAssoc value ifNotNil: [ :ref | ref spiderClass ]) ]) ] ].
	^ records
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> datetime [
	^ datetime
]

{ #category : #queries }
SPGlorpMonticelloPackage >> descendants [

	| query |
	
	query := Query read: self class where: [ :each | 
			each ancestors anySatisfy: [ :x | x = self ] ].
		
	^ self glorpSession execute: query
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> fullName [

	^self name, '-', self author, '.', self version asString
]

{ #category : #comparing }
SPGlorpMonticelloPackage >> hash [

	^ self mcId hash
]

{ #category : #initialization }
SPGlorpMonticelloPackage >> initWithName: aName mcId: aMcId version: mcVersion branch: aBranch author: mcAuthor datetime: aTimestamp message: aMessage package: aPackeOrNil ancestors: anAncestorColl [

	name := aName.
	mcId := aMcId.
	version := mcVersion.
	branch := aBranch.
	author := mcAuthor.
	datetime := aTimestamp.
	message := aMessage.
	package := aPackeOrNil.
	ancestors := anAncestorColl sorted asArray
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> mcId [
	^ mcId
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> message [
	^ message
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> name [
	^ name
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> package [
	^ package
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> rootId [
	^ rootId
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> uuid [

	| newUUID |
	
	newUUID := UUID nilUUID.
	mcId doWithIndex: [ :b :i | newUUID at: i put: b ].
	^ newUUID
]

{ #category : #accessing }
SPGlorpMonticelloPackage >> version [
	^ version
]
