# settingable [![Build Status](https://travis-ci.org/medcat/settingable.svg)](https://travis-ci.org/medcat/settingable)

* [Homepage](https://rubygems.org/gems/settingable)
* [Documentation](http://rubydoc.info/gems/settingable/frames)
* [Email](mailto:me@medcat.me)

## Install

    $ gem install settingable

## Description

A Settings module for your application.  Its job is to make handling
user-definable settings easy for you, so you can focus on the more
important parts of your library.  The main component of it is the
`Settingable::Settings` module.  Just include that in a class, and
you're good to go.

```Ruby
module MyLibrary
  class Settings
    include Settingable::Settings
end
```

The `Settings` module provides a few methods.  First, it defines the
`.instance` class method.  This returns a single instance upon
repeated invocation, like the `Singleton` module.  Then, it defines
the `.configure` method.  This is used to (*ahem*) configure the
settings.  It both yields itself and runs it in its context, so you
may configure it however you like.  It also forwards the methods
`.[]`, `.[]=`, and `.fetch` on to the actual instance itself as well.

The instance forwards the `#[]`, `#[]=`, `#fetch`, and `#key?` method
on to the `Settingable::Hash` powering the settings (see the
documentation for more).  The instance can also accept any other
methods.  If the method ends in an equal sign (i.e. a setter method),
it is forwarded to `#[]=`; otherwise, it is forwarded to `#[]`.

Here's a few examples.

```Ruby
MyLibrary::Settings.configure do |config|
  # These two are the same.
  config.value = 2
  config[:value] = 2
end

# These all are the same, and return the same value.
MyLibrary::Settings.value
MyLibrary::Settings[:value]
MyLibrary::Settings["value"]
MyLibrary::Settings.instance.value
MyLibrary::Settings.instance[:value]
MyLibrary::Settings.instance["value"]
```

If you attempt to access a setting value that isn't defined, even if
you use the regular accessor (`#[]`), a `KeyError` will be raised.
So, the module provides a `.default_settings` method, for you to
provide default values for the settings.

```Ruby
module MyLibrary
  class Settings
    include Settingable::Settings

    default_settings foo: "bar"
  end
end
```

Now, check it out.

```Ruby
MyLibrary::Settings[:foo] # => "bar"
MyLibrary::Settings[:bar] # ! KeyError
```
