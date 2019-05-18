Class {
	#name : #SPMonticelloPackageTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-MC-Tests'
}

{ #category : #accessing }
SPMonticelloPackageTest >> getTestPackages [

	^ SPMonticelloTestPackages new
]

{ #category : #accessing }
SPMonticelloPackageTest >> testPackageV1 [

	| repo mcVersion mcPackage |

	repo := SPiderImageContext new mcPackageRepo.

	mcVersion := self getTestPackages testPackageV1.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.

]
