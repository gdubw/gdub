# What's gdub?
gdub (`gw` on the command line) is a `gradle` / `gradlew` wrapper. Not to be
confused with the [Gradle][] [Wrapper][], `gw` invokes `./gradlew` on
projects where one is configured, and falls back to use the `gradle` from the
`$PATH` if a wrapper is not available. Also, `gw` is 66% shorter to type than `gradle`
and 78% shorter to type than `./gradlew`.

[Gradle]:  http://www.gradle.org
[Wrapper]: http://www.gradle.org/docs/current/userguide/gradle_wrapper.html

# Installation
There are now a few ways to install gdub, with more on the way. Use whichever is
most convenient for you or feel free to [suggest another][]!

[suggest another]: https://github.com/dougborg/gdub/issues

## Homebrew
If you are on OSX and not using [homebrew][], I'm not quite sure what to do with
you. Install gdub with homebrew like so:

```bash
brew install gdub
```

[homebrew]: https://brew.sh

## MacPorts
If you use [MacPorts](https://www.macports.org), you can install gdub like so:

```bash
sudo port install gdub
```

## bpkg
If you use [bpkg][], you may install like so:

```bash
bpkg install dougborg/gdub -g
```

[bpkg]: https://www.bpkg.sh

## Installing gdub from source
You will probably want to [install Gradle][] first. While this is not
technically necessary if all your projects are using a Gradle Wrapper, it is a
good idea to have the latest version of `gradle` available system-wide because
some handy Gradle features are available outside the context of an existing
project.

[install Gradle]: https://gradle.org/install/

Check out a copy of the gdub repository. Then, either add the gdub `bin`
directory to your `$PATH`, or run the provided `install` command with the
location to the prefix in which you want to install gdub. The default prefix is
`/usr/local`.

For example, to install gdub into `/usr/local/bin`:

```bash
git clone https://github.com/dougborg/gdub.git
cd gdub
./install
```

Note: you may need to run `./install` with `sudo` if you do not have
permission to write to the installation prefix.

## Aliasing the `gradle` command
For maximum fidelity add a `gradle` alias to `gw` to your shell's configuration
file.

Example *bash*:

```bash
echo "alias gradle=gw" >> ~/.bashrc
source ~/.bashrc
```

From now on you can just type `gradle ...` from wherever you are and `gw` takes
care of the rest. Happiness ensues!

# Why gdub?

## The problems with `gradle` and `gradlew`
gdub is a convenience for developers running local Gradle commands and addresses
a few minor shortcomings of `gradle` and `gradlew`'s commandline behaviour.
These are known issues, and they are set to be addressed in future versions of
Gradle. If you are interested in the discussions surrounding them, check out:

  - [Issue Gradle-2429](http://issues.gradle.org/browse/Gradle-2429)
  - [Spencer Allain's Gradle Forum Post](http://gsfn.us/t/33g0l)
  - [Phil Swenson's Gradle Forum Post](http://gsfn.us/t/39h67)

Here are the issues I feel are most important, and the ones gdub attempts to
address:

### You have to provide a relative path to `build.Gradle`
If you are using the `gradle` command, and you are not in the same directory as
the `build.gradle` file you want to run, you have to provide `gradle` the path.
Depending on where you happen to be, this can be somewhat cumbersome:

```bash
$ pwd
~/myProject/src/main/java/org/project
$ gradle -b ../../../../../build.gradle build
```

With `gw`, this becomes:

```bash
$ gw build
```

### You have to provide a relative path to `gradlew`
If you are using `gradlew` and you want to run your build, you need to do
something similiar and provide the relative path to the `gradlew` script:

```bash
$ pwd
~/myProject/src/main/java/org/project/stuff
$ ../../../../../../gradlew build
```

Again, with `gw` this becomes:

```bash
$ gw build
```

### You have a combination of the above problems
I don't even want to type out an example of this, let alone do it on a
day-to-day basis. Use your imagination.

### Typing `./gradlew` to run the Gradle wrapper is kind of inconvenient
Even with tab completion and sitting at the root of your project, you have to
type at least `./gr<tab>`. It gets a bit worse if you happen to have a
`Gradle.properties` file, and with the Gradle wrapper, you have a `gradle`
directory to contend with as well. A simple alias would solve this problem, but
you still have the other (more annoying) issues to contend with.

### You meant to use the project's `gradlew`, but typed `gradle` instead
This can be a problem if the project you are building has customizations to the
Gradle wrapper or for some reason is only compatible with a certain version of
Gradle that is configured in the wrapper. If you know the project uses Gradle,
you may be tempted to just use your own system's Gradle binary. This might be
ok, or it might cause the build to break, but if a project has a `gradlew`, it
is a pretty safe bet you should use it, and not whatever Gradle distribution you
happen to have installed on your system.

# The `gw` payoff
Anywhere you happen to be on your project, you can run the Gradle tasks of your
project by typing `gw <tasks>`, regardless of whether you use the Gradle Wrapper
in your project or not.

`gw` works by looking upwards from your current directory and will run the
nearest `build.Gradle` file with the nearest `gradlew`. If a `gradlew` cannot
be found, it will run the nearest `build.Gradle` with your system's Gradle. This
is probably always what you want to do if you are running Gradle from within a
project's tree that uses the Gradle build system.
