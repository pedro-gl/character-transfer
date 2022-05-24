## Transfer Character
### Transfer Character for CABAL ONLINE

This stored procedure transfers the character from one account to another account.

### Usage

After adding the stored procedure to your Server01 database, run this query to transfer a character:

```sql
EXEC [Server01].[dbo].[Transfer_Character] '@Origin_CharacterIdx', '@Target_UserNum';
```

- **@Origin_CharacterIdx** = id of the character to be transferred.
- **@Target_UserNum** = account to which the character will be sent.
