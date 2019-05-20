Class {
	#name : #SPTransactionsListView,
	#superclass : #SPListView,
	#instVars : [
		'transactions'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPTransactionsListView >> openItem: aTransaction [

	self show: (SPTransactionDetailsView new
		transaction: aTransaction;
		yourself)
]

{ #category : #accessing }
SPTransactionsListView >> renderRow: aTransaction on: html [

	html tableData: [
		html anchor
			callback: [ self openItem: aTransaction ]; 
			with: aTransaction id ].
	html tableData: [ self renderDateTime: aTransaction startedAt on: html ].
	html tableData: aTransaction message.
]

{ #category : #accessing }
SPTransactionsListView >> renderTableBodyOn: html [

	self transactions do: [ :each |
		html tableRow: [ 
			self renderRow: each on: html ] ]
]

{ #category : #accessing }
SPTransactionsListView >> renderTableHeadOn: html [

	html tableHeading: '#'.
	html tableHeading: 'Timestamp (UTC)'.
	html tableHeading: 'Message'
]

{ #category : #accessing }
SPTransactionsListView >> title [

	^ 'Latest import transactions'
]

{ #category : #accessing }
SPTransactionsListView >> transactions [

	^ transactions ifNil: [ transactions := self context sessionRepo latestTransactions: 40 ]
]
