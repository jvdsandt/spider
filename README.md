[![Build Status](https://travis-ci.org/jvdsandt/spider.svg?branch=master)](https://travis-ci.org/jvdsandt/spider)

# spider
The Smalltalk source graph

## Code loading

```smalltalk
Metacello new
	baseline: 'Spider';
	repository: 'github://jvdsandt/spider/src';
	onConflictUseLoaded;
	load: #( 'all' ).
```  
  
  
