## Singleton Generator - Swift 2.0
#### Protocol-Oriented Programming

Here is how to use the generator:

```/* create/extend some structer type (struct or enum) */
    extension SomeValueType: SingletonType {
    
         // implement the designated initializer `init`
         // if it's not already provided
         
         init() {
             // set up all your values here 
             // or call another initializer
         }
    }
    
    /* create/extend your custom class */
    class A : SingletonType {
    
        required init() { /* do custom work here */ }
    }```
    
Now lets see how it looks with an actual type:

    /* String has already an `init` as an initializer */
    extension String : SingletonType {}
    
Get the singleton instance or set it if it's not yet created:
    
    /* remember structer types are passed by value */
    /* any changes on the new var won't affect the */
    /* the singleton instnace we have created      */
    
    var myStringSingleton = String.getSingleton
    
There are two different setter to set the singleton instance. Both can return the new instance if needed. If the singleton instance is not yet created the setter will create one automatically. You can also provide the first value by yourself. This is helpful when you want initialize your instace with a custom initializer and not the designated `init()` from the `SingletonType` protocol. 

##### Setter #1:
    
    /* will initially set the String singleton with "new string" */
    String.setSingleton { (_) -> String in "new string" }
    
    /* we can also ignore the `(_) -> String in` like this */
    /* this will now replace "new string" with new value */
    String.setSingleton { $0; "some other string" }
    
    String.setSingleton { (singletonInstnace) -> String in 
    
        /* do some work here */
        return newValue // bacause it's a structer type
    }
    
    /* pass the value to itself, this is useless but you've got the point */
    String.setSingleton { $0 }
    
    /* return the new value */
    let mySingletonString = String.setSingleton { return /* do some work */ }
    
    /* modify class instance inside the closure */
    A.setSingleton { $0.someVariable = newValue; return $0 }
    
    /* singleton instances of a class can also be modified outside the closure */
    let classSingleton = A.setSingleton { $0 } // better would be A.getSingleton
    
    classSingleton.someVariable = newValue
    
To break out of the closure you also can use the second setter with a custom operator `«`. The shortcut on OS X is `alt` + `q`.

##### Setter #2:

    /* with this setter we can do a bit more, because now there are no closure in our way */
    
    let customClassInstance = A( /* some custom initializing */ )
    customClassInstance.someVar = /* do as you like */
    
    /* lets set the singleton with our custom instance */
    /* this will only work if you're calling the setter */
    /* for this SingletonType for the first time */
    
    A.setSingleton « customClassInstance // voila
    
    String.setSinglton « "hello world"
    
    /* we can also do it like this, but I prefer my custom syntax */
    String.self « "42"
    
###### TODO:
 - More examples.
 - Code documentation.
 - Wait for 2-3 needed Swift features so the generator can create true singletons.
 - Maybe some improvements to the code, when Swift 2.0 is out of beta. 


Everything is under *MIT License*.
