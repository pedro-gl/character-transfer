## Transfer Character
### Transfer Character for CABAL ONLINE

This procedure transfers the character from one account to another account.

### Usage

After adding the procedure to your Server01 database, run this query to transfer a character:

`EXEC Server01.dbo.Transfer_Character 'Origin CharacterIdx', 'Target UserNum';`

- **Origin CharacterIdx** = id of the character to be transferred.
- **Target UserNum** = account to which the character will be sent.
