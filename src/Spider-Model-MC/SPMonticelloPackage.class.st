Class {
	#name : #SPMonticelloPackage,
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
SPMonticelloPackage class >> name: aName mcId: aMcId version: mcVersion branch: aBranch author: mcAuthor datetime: aTimestamp message: aMessage package: aPackeOrNil ancestors: anAncestorColl [

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
SPMonticelloPackage >> <= other [

	^ datetime <= other datetime
]

{ #category : #comparing }
SPMonticelloPackage >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ name = other name and: [ self mcId = other mcId ]
]

{ #category : #accessing }
SPMonticelloPackage >> ancestors [
	^ ancestors
]

{ #category : #accessing }
SPMonticelloPackage >> author [
	^ author
]

{ #category : #accessing }
SPMonticelloPackage >> branch [
	^ branch
]

{ #category : #actions }
SPMonticelloPackage >> createClassDiffRecords [

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
SPMonticelloPackage >> datetime [
	^ datetime
]

{ #category : #queries }
SPMonticelloPackage >> descendants [

	| query |
	
	query := Query read: self class where: [ :each | 
			each ancestors anySatisfy: [ :x | x = self ] ].
		
	^ self glorpSession execute: query
]

{ #category : #accessing }
SPMonticelloPackage >> fullName [

	^self name, '-', self author, '.', self version asString
]

{ #category : #comparing }
SPMonticelloPackage >> hash [

	^ self mcId hash
]

{ #category : #initialization }
SPMonticelloPackage >> initWithName: aName mcId: aMcId version: mcVersion branch: aBranch author: mcAuthor datetime: aTimestamp message: aMessage package: aPackeOrNil ancestors: anAncestorColl [

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
SPMonticelloPackage >> mcId [
	^ mcId
]

{ #category : #accessing }
SPMonticelloPackage >> message [
	^ message
]

{ #category : #accessing }
SPMonticelloPackage >> name [
	^ name
]

{ #category : #accessing }
SPMonticelloPackage >> package [
	^ package
]

{ #category : #accessing }
SPMonticelloPackage >> rootId [
	^ rootId
]

{ #category : #accessing }
SPMonticelloPackage >> uuid [

	| newUUID |
	
	newUUID := UUID nilUUID.
	mcId doWithIndex: [ :b :i | newUUID at: i put: b ].
	^ newUUID
]

{ #category : #accessing }
SPMonticelloPackage >> version [
	^ version
]
