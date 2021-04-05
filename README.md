# Turris translations

This repository contains translations mostly for Foris, and it's plugins, which
were done through [Weblate](https://hosted.weblate.org/projects/turris/).

## How to update it from Weblate

You need to look at [Weblate](https://hosted.weblate.org/projects/turris/). Choose
one of those components (translation), you'd like to update.

As an example, I choose *Turris: user-notify*. Click on it and go to tab
Information. There, you'd need to copy the URL for the repository with Weblate
translations.

1. **Add remote repository**
  Just use the URL for the repository with Weblate translations, you'd need to
  add it as a remote repository, so you'd be able to merge it.
  ```
  git remote add weblate https://hosted.weblate.org/git/turris/pkglists/
  ```
  
  Now you are ablo to fetch Weblate translations:
  ```
  git fetch weblate master
  ```


2. **Merge it**
  It's important not to do it with git merge fast forward (ff) as it won't
  create a merge commit.
  ```
  git merge --no-ff weblate/master
  ```
  
  If there's any conflict, you need to solve it before you're able to do push.
  ```
  git push origin master
  ```


3. **Update in Turris OS release**
  The last two things, what you need to do for applying it into the release or
  before you're compiling it locally.
  
  - Bump the version in the package *turris-translations*, which can be found in
    the repository in
    [turris-os-packages](https://gitlab.labs.nic.cz/turris/turris-os-packages/).
  
  - Update list of translations at the bottom of *turris-translations* Makefile to
    contain new translated languages.
