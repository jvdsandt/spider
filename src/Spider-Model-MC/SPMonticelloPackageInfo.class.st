Class {
	#name : #SPMonticelloPackageInfo,
	#superclass : #Object,
	#instVars : [
		'name',
		'count',
		'authors',
		'minDatetime',
		'maxDatetime'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #'instance creation' }
SPMonticelloPackageInfo class >> named: packageName [

	^ self new initWithName: packageName
]

{ #category : #comparing }
SPMonticelloPackageInfo >> <= other [

	^ name <= other name
]

{ #category : #accessing }
SPMonticelloPackageInfo >> authors [
	^ authors
]

{ #category : #accessing }
SPMonticelloPackageInfo >> count [
	^ count
]

{ #category : #initialization }
SPMonticelloPackageInfo >> initWithName: aString [

	name := aString.
	count := 0.
	authors := Set new
]

{ #category : #accessing }
SPMonticelloPackageInfo >> maxDatetime [
	^ maxDatetime
]

{ #category : #accessing }
SPMonticelloPackageInfo >> minDatetime [
	^ minDatetime
]

{ #category : #accessing }
SPMonticelloPackageInfo >> name [
	^ name
]

{ #category : #processing }
SPMonticelloPackageInfo >> process: mcPackage [

	count := count + 1.
	minDatetime := minDatetime isNil
		ifTrue: [ mcPackage datetime ]
		ifFalse: [ minDatetime min: mcPackage datetime ].
	maxDatetime := maxDatetime isNil
		ifTrue: [ mcPackage datetime ]
		ifFalse: [ maxDatetime max: mcPackage datetime ].
	authors add: mcPackage author
]
