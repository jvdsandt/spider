Class {
	#name : #SPTransactionsListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPTransactionsListView >> list [

	^ list ifNil: [ list := self context sessionRepo latestTransactions: 40 ]
]

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

	self list do: [ :each |
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
