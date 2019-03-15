Class {
	#name : #PLMainWindowTest,
	#superclass : #PLAbstractSpecTestCase,
	#instVars : [
		'imageRepository'
	],
	#category : #'PharoLauncher-Spec-Tests'
}

{ #category : #asserting }
PLMainWindowTest >> assert: anInstance hasToolbarButtonLabelled: aLabel [

	self assert: (anInstance window toolBar items values flattened anySatisfy: [ :any |
		any label = aLabel ])
]

{ #category : #asserting }
PLMainWindowTest >> assertImageColumn: aColumnName equals: aValue [ 

	| column |
	column := instance imageTable columns detect: [ :e | e title = aColumnName ].
	self assert: (column readObject: imageRepository images first) equals: aValue
]

{ #category : #tests }
PLMainWindowTest >> setUp [ 

	super setUp.

	imageRepository := PLMemoryImageRepository new.
	imageRepository addImage: testImage.
	
	instance := PLMainWindow on: imageRepository.
	instance application: SpecApplication new.
	window := instance openWithSpec

]

{ #category : #tests }
PLMainWindowTest >> testClickNewButtonOpensCreateImageDialog [

	| newButton newImageDialog |
	newButton := instance window toolBar itemNamed: 'New'.
	newButton click.
	
	newImageDialog := instance application windows detect: [ :any | any model isKindOf: PLCreateImageDialogPresenter ].
	self assert: newImageDialog isDialog
]

{ #category : #tests }
PLMainWindowTest >> testHasANewButtonInToolbar [

	self assert: instance hasToolbarButtonLabelled: 'New'
]

{ #category : #tests }
PLMainWindowTest >> testImageArchColumnDisplaysCorrectValue [

	self assertImageColumn: 'Architecture' equals: '32'
]

{ #category : #tests }
PLMainWindowTest >> testImageModifiedColumnDisplaysCorrectValue [

	self assertImageColumn: 'Modified' equals: 'just now' asText
]

{ #category : #tests }
PLMainWindowTest >> testImageNameColumnDisplaysCorrectValue [

	self assertImageColumn: 'Name' equals: 'TestImage'
]

{ #category : #tests }
PLMainWindowTest >> testImagesHasArchColumn [

	self assert: (instance imageTable columns anySatisfy: [ :e | e title = 'Architecture' ])
]

{ #category : #tests }
PLMainWindowTest >> testImagesHasModifiedColumn [

	self assert: (instance imageTable columns anySatisfy: [ :e | e title = 'Modified' ])
]

{ #category : #tests }
PLMainWindowTest >> testImagesHasNameColumn [

	self assert: (instance imageTable columns anySatisfy: [ :e | e title = 'Name' ])
]

{ #category : #tests }
PLMainWindowTest >> testLauncherHasButton [

	self assert: (window hasPresenter: instance runButton)
]

{ #category : #tests }
PLMainWindowTest >> testLauncherHasImages [

	self assert: (window hasPresenter: instance imageTable)
]

{ #category : #tests }
PLMainWindowTest >> testNewLauncherHasDisabledRunButton [

	self deny: instance runButton isEnabled 
]

{ #category : #tests }
PLMainWindowTest >> testNewLauncherHasEmptySelection [

	self assert: instance imageTable selection isEmpty
]

{ #category : #tests }
PLMainWindowTest >> testNoSelectionDisablesRunButton [

	instance imageTable unselectAll. 
	self deny: instance runButton isEnabled
]

{ #category : #tests }
PLMainWindowTest >> testNonSelectionAndClickRunButtonLaunchesImage [

	instance runButton click.
	
	self deny: testImage isLaunched
]

{ #category : #tests }
PLMainWindowTest >> testPharoLauncherApplicationHasSingleWindowAtStart [

	self assert: instance application windows size equals: 1
]

{ #category : #tests }
PLMainWindowTest >> testPharoLauncherApplicationSingleWindowIsMainWindow [

	self assert: instance application windows anyOne model equals: instance
]

{ #category : #tests }
PLMainWindowTest >> testSelectingImageAndClickRunButtonLaunchesImage [

	instance imageTable selectIndex: 1.
	instance runButton click.
	
	self assert: testImage isLaunched
]

{ #category : #tests }
PLMainWindowTest >> testSelectionEnablesRunButton [

	instance imageTable selectIndex: 1. 
	self assert: instance runButton isEnabled
]

{ #category : #tests }
PLMainWindowTest >> testSelectionUpdatesDescriptionPanel [

	instance imageTable selectIndex: 1. 
	self assert: instance descriptionPanel model equals: testImage
]

{ #category : #tests }
PLMainWindowTest >> testSmoke [

	"I am a fucking smoke seller"
]

{ #category : #tests }
PLMainWindowTest >> testWindowTitle [

	self assert: window title equals: 'Pharo Launcher'.
]