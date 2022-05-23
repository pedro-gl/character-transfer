ALTER PROCEDURE [dbo].[Transfer_Character] (
	@OriginCharacterIdx bigint,
	@TargetUserNum bigint
)
AS
BEGIN
	DECLARE @r_result int;
	DECLARE @r_OK int = 1;
	DECLARE @r_FAILED int = 0;
	DECLARE @r_originConnected int = -1;
	DECLARE @r_targetConnected int = -2;
	DECLARE @r_originNotFound int = -3;
	DECLARE @r_targetNotFound int = -4;
	DECLARE @r_targetNoSpace int = -5;
	
	-- Search for origin
	DECLARE @OriginUserNum bigint;
	DECLARE @OriginLogin smallint;
	SELECT @OriginUserNum = UserNum, @OriginLogin = Login FROM Account.dbo.cabal_auth_table WHERE UserNum = @OriginCharacterIdx/8;
	IF(@@ROWCOUNT <= 0) BEGIN SELECT @r_originNotFound RETURN; END;
	IF(@OriginLogin != 0) BEGIN SELECT @r_originConnected RETURN; END;
	
	-- Search for target
	DECLARE @TargetLogin smallint;
	SELECT @TargetLogin = Login FROM Account.dbo.cabal_auth_table WHERE UserNum = @TargetUserNum;
	IF(@@ROWCOUNT <= 0) BEGIN SELECT @r_targetNotFound RETURN; END;
	IF(@TargetLogin != 0) BEGIN SELECT @r_targetConnected RETURN; END;
	
	-- Target slot check
	DECLARE @TargetCharacterCount smallint;
	SELECT @TargetCharacterCount = COUNT(CharacterIdx) FROM Server01.dbo.cabal_character_table WHERE CharacterIdx/8 = @TargetUserNum;
	IF(@TargetCharacterCount >= 6) BEGIN SELECT @r_targetNoSpace END;
	
	-- Assign new characteridx
	DECLARE @TargetCharacterIdx bigint;
	SET @TargetCharacterIdx = (@TargetUserNum*8) + (@TargetCharacterCount + 1);
	
	-- Lock origin and target
	UPDATE Account.dbo.cabal_auth_table SET AuthType = 2 WHERE UserNum = @OriginUserNum;
	UPDATE Account.dbo.cabal_auth_table SET AuthType = 2 WHERE UserNum = @TargetUserNum;
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE backup_14th_CABAL_BBEAD_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_CHARACTER_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_CRAFT_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_EMS_USERSTATE_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_EQUIPMENT_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_INVENTORY_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_QDDATA_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_QUESTDATA_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_QUICKSLOT_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_SKILLLIST_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_SOUL_ABILITY_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE backup_14th_CABAL_WAREXP_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_achievement_history SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_achievement_open SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_achievement_title SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_Assistant_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_bbead_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_character_style_backup SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_character_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_craft_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			DELETE FROM cabal_DungeonPoint_table WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_ems_userstate_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			DELETE FROM cabal_equipment_lock_table WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_equipment_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_Forcecalibur_Owner SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			
			UPDATE cabal_Inventory_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			--DELETE FROM cabal_Inventory_table WHERE CharacterIdx = @OriginCharacterIdx
			
			UPDATE cabal_item_extend_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			DELETE FROM cabal_LordOfWar_point_table WHERE CharacterIdx = @OriginCharacterIdx
			DELETE FROM cabal_LordOfWar_Rank_table WHERE CharacterIdx = @OriginCharacterIdx
			DELETE FROM cabal_LordOfWar_table WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_qddata_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_questdata_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_quickslot_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_quickslot_table_backup SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_saved_buff_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_skilllist_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_skilllist_Table_backup SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_sold_item_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_soul_ability_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Cabal_Title_PlayHistory SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Cabal_Title_Show_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Cabal_Title_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_title_viaserver_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_WarExp_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_cabal_achievement_title SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_cabal_character_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_cabal_character_table_backup SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_cabal_inventory_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_cabal_item_extend_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE deleted_Cabal_Title_PlayHistory SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_cabal_equipment_table_after SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_cabal_equipment_table_before SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_cabal_inventory_table_after SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_cabal_inventory_table_before SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_deleted_cabal_character_table_after SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_deleted_cabal_character_table_before SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_deleted_cabal_inventory_table_after SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE ehchant_change_16TH_deleted_cabal_inventory_table_before SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE enchant_before_bbead_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE enchant_before_deleted_character_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE enchant_before_deleted_inventory_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE enchant_before_equipment_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE enchant_before_inventory_table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE IPVG_cabal_character_table_1007 SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE IPVG_cabal_character_table_1104 SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE LevUpEventWinTable SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE SPLIT_EQUIPMENT_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE SPLIT_INVENTORY_TABLE SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Temp_CheckBBeadData_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Temp_CheckInventoryItem_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE Temp_CheckMailItem_Table SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE TempDeleteQuestDataTable SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE tempLog_080602 SET CharacterIdx = @TargetCharacterIdx WHERE CharacterIdx = @OriginCharacterIdx
			UPDATE cabal_pet_table SET OwnerCharIdx = @TargetCharacterIdx WHERE OwnerCharIdx = @OriginCharacterIdx
			SELECT @r_result = @r_OK;
			COMMIT;
			GOTO finish;
		END TRY  
		BEGIN CATCH
			ROLLBACK;
			SELECT @r_result = @r_FAILED;
			GOTO finish;
		END CATCH
		
	finish:
		UPDATE Account.dbo.cabal_auth_table SET AuthType = 1 WHERE UserNum = @OriginUserNum;
		UPDATE Account.dbo.cabal_auth_table SET AuthType = 1 WHERE UserNum = @TargetUserNum;
		SELECT @r_result RETURN;
END