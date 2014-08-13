# What's gdub?

gdub (`gw` on the command line) is a `gradle` / `gradlew` wrapper. This is 
not to be confused with the [Gradle Wrapper](http://www.gradle.org/). gdub
actually uses the Gradle Wrapper on projects where one is configured, but 
falls back to use the system-installed Gradle if a wrapper is not availble.

## The problems with `gradle` and `gradlew`

gdub is a convienence for developers running local gradle commands and addresses
a few minor shortcomings of `gradle` and `gradlew`'s commandline behaviour. These
are known issues, and they are set to be addressed in future versions of Gradle. If
you are interested in the discussions surrounding them, check out:

  - [Issue GRADLE-2429](http://issues.gradle.org/browse/GRADLE-2429)
  - [Spencer Allain's Gradle Forum Post](http://forums.gradle.org/gradle/topics/gradlew_scripts_in_gradle_bin_to_find_gradlew_scripts_upwards_within_project_space)
  - [Phil Swenson's Gradle Forum Post](http://forums.gradle.org/gradle/topics/is_there_a_way_to_make_gradlew_available_within_all_sub_directories)

Here are the issues I feel are most important, and the ones gdub attempts to
address:

### You have to provide a relative path to `build.gradle`

If you are using the `gradle` command, and you are not in the same directory
as the `build.gradle` file you want to run, you have to provide `gradle` the path.
Depending on where you happen to be, this can be somewhat cumbersome:

    ~/myProject/src/main/java/org/project/stuff$ gradle -b ../../../../../../build.gradle build
    # Or maybe:
    ~/myProject/src/main/java/org/project/stuff$ gradle -b ~/myProject/build.gradle build    

With `gw`, this becomes:

    ~/myProject/src/main/java/org/project/stuff$ gw build

### You have to provide a relative path to `gradlew`

If you are using `gradlew` and you want to run your build, you need to do
something similiar and provide the relative path to the `gradlew` script:

    ~/myProject/src/main/java/org/project/stuff$ ../../../../../../gradlew build

Again, with `gw` this becomes:

    ~/myProject/src/main/java/org/project/stuff$ gw build

### You have a combination of the above problems

I don't even want to type out an example of this, let alone do it on a
day-to-day basis. Use your imagination.

### Typing `./gradlew` to run the gradle wrapper is kind of inconvenient

Even with tab completion and sitting at the root of your project, you have to
type at least `./gr<tab>`. It gets a bit worse if you happen to have a
`gradle.properties` file, and with the gradle wrapper, you have a `gradle`
directory to contend with as well. A simple alias would solve this problem, but
you still have the other (more annoying) issues to contend with.

### You meant to use the project's `gradlew`, but typed `gradle` instead

This can be a problem if the project you are building has customizations to the
gradle wrapper or for some reason is only compatible with a certain version of
gradle that is configured in the wrapper. If you know the project uses gradle, 
you may be tempted to just use your own system's gradle binary. This might be ok,
or it might cause the build to break, but if a project has a `gradlew`, it is a 
pretty safe bet you should use it, and not whatever Gradle distribution you 
happen to have installed on your system.

## The `gw` payoff

Anywhere you happen to be on your project, you can run the gradle tasks of your
project by typing `gw <tasks>`, regardless of whether you use the Gradle Wrapper
in your project or not.

`gw` works by looking upwards from your current directory and will run the
nearest `build.gradle` file with the nearest `gradlew`. If a `gradlew` cannot
be found, it will run the nearest `build.gradle` with your system's gradle. This
is probably always what you want to do if you are running gradle from within a
project's tree that uses the Gradle build system.

# Installing gdub from source

You will probably want to install [Gradle](http://www.gradle.org) first. While
this is not technically necessary if all your projects are using a Gradle
Wrapper, it is a good idea to have Gradle available system-wide because some
handy Gradle features are available outside the context of an existing project.

Check out a copy of the gdub repository. Then, either add the gdub `bin`
directory to your `$PATH`, or run the provided `install` command with the
location to the prefix in which you want to install gdub.

For example, to install gdub into `/usr/local`:

    $ git clone https://github.com/dougborg/gdub.git
    $ cd gdub
    $ ./install /usr/local

Note that you may need to run `install` with `sudo` if you do not have
permission to write to the installation prefix.

## Aliasing the `gradle` command
For maximum fidelity add a `gradle` alias to `gw` to your shell's configuration file.

Example *bash*:

```bash
echo "alias gradle=gw" >> ~/.bashrc
source ~/.bashrc
```

From now on you can just type `gradle ...` from wherever you are and `gw` takes care of the rest. Happiness ensues!
