# Microsoft Graph Single page Scripts

Here is a collection of admin scripts are written in a way have no dependency to anything but them self.

By applying these restrictions we will able to copy paste the script, make small changes as needed and then execute them from any windows machine.

## Why!?
As consultant I have come across many situations, that required me to run a script from an admins computer. 
In these cases I have had to give them specific instructions to install and configure there machines to my specifications. 
In some case writing the docs and guiding them through it took longer then writing the scripts them self. 
This of course creates unnecessary cost that could have be spent better in other places within the project it self. 

My Hope with this project is to create a reusable set of tool that can by anyone, to achieve a maximum effect at minimum cost.

## Scripts

- oneDrive
  - [List-UserFiles](./scripts/oneDrive/List-userFiles/README.md)
  - [Remove-UsersFileItems](.)

## Contributions

### Rules

1. The scripts must be able to be copy pasted on any windows machine and do there task.
2. The scripts should not be too long, so try to create script that do single tasks and can work together.

### Snippets 

Snippets are highly encouraged. Due to our restrictions will end up reusing the same code section, by being able to drop code the same section of code in different scripts we ensure consistency and we use regex to find and update bugs and issues. 