#!/bin/bash

#Wipe out the Smart Connection Book Support folder, if it exists
smartConnectionBookSupportDirectory="/Applications/Adobe InDesign CC 2015/Scripts/Scripts Panel/Smart Connection Book Support"                                        

if [ -d "${smartConnectionBookSupportDirectory}" ]
then
        rm -rf "${smartConnectionBookSupportDirectory}"                                                                                                               
fi

#List of receipt names to forget
receiptsToForget=( ElementLabel ElementLabelUI InDesign PluginConfig SCCoreContent SCCoreDataLink SCCoreDataLinkUI SCCoreInDesign SCCoreStickyNotes SCCoreStickyNotesUI SCCoreTemplate SCEntAccessUI SCEntEditioning SCEntEditioningUI SCEnterprise SCEnterpriseUI SCEntFields SCEntFieldsUI SCEntScripting SCEntWidgets SCProElementsPanel SCProFramesInDesign SCProInDesignUI SCProPanel SmartConnectionBookSupport SmartImage SmartImageUI SmartJump SmartJumpInDesignUI style WoodWing woodwingui WoodWingWidgets WoodWingZXP WWActivate WWSettings )

#Forget the single outlier receipt
if pkgutil --pkg-info com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg > /dev/null 2>&1
then
	pkgutil --forget com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg
else
	echo Receipt to remove com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg NOT FOUND
fi

#Forget the receipts in the receiptsToForget array
#Since Woodwing uses version names in the package receipts, need to use a regex to remove all receipts with a particular name
for receiptName in "${receiptsToForget[@]}"
do
	if pkgutil --pkgs=com\\.WoodWing\\.smartConnectionForAdobeCc2015V[\\d]+\\."${receiptName}"\\.pkg > /dev/null 2>&1
	then
		pkgutil --pkgs=com\\.WoodWing\\.smartConnectionForAdobeCc2015V[\\d]+\\."${receiptName}"\\.pkg | tr '\n' '\0' | xargs -n 1 -0 pkgutil --forget 
	else
		echo Receipt to remove com.WoodWing.smartConnectionForAdobeCc2015V\*version\*."${receiptName}".pkg NOT FOUND
	fi
done
