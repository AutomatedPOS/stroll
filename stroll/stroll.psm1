﻿#region Classes
class Checklist{
    [string]$stigid
    [string]$title
    [string]$version
    [string]$release
    [System.IO.FileSystemInfo]$FileInfo
    [System.Xml.XmlNode]$xml
    [string]$hash
    [string]$uniqueID
    [string]$HOST_NAME
    [string]$WEB_DB_INSTANCE
    [string]$WEB_DB_SITE
    [string]$ROLE
    [string]$TECH_AREA
    [string]$WEB_OR_DATABASE
    [string]$HOST_IP
    [string]$HOST_MAC
    [string]$HOST_FQDN
    [string]$TARGET_COMMENT
    [string]$AssetType
    [System.Collections.ArrayList]$VULNS = @()

    Checklist([string]$pathToChecklist){
        $this.FileInfo = Get-ChildItem -Path $pathToChecklist
        $this.xml = (Select-Xml -Path $this.FileInfo.FullName -XPath /).node
        $this.stigid = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("stigid")]
        $this.title = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("title")]
        $this.version = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("version")]
        $this.release = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("releaseinfo")]
        $this.AssetType = $this.xml.CHECKLIST.ASSET.ASSET_TYPE
        $this.release = $this.release.Replace("Release: ","")
        $this.release = $this.release -replace " Benc.*",""
        $this.HOST_NAME = $this.xml.CHECKLIST.ASSET.HOST_NAME.ToUpper()
        $this.HOST_IP = $this.xml.CHECKLIST.ASSET.HOST_IP
        $this.HOST_MAC = $this.xml.CHECKLIST.ASSET.HOST_MAC.ToUpper()
        $this.HOST_FQDN = $this.xml.CHECKLIST.ASSET.HOST_FQDN.ToUpper()
        $this.WEB_OR_DATABASE = $this.xml.CHECKLIST.ASSET.WEB_OR_DATABASE.ToLower()
        $this.WEB_DB_INSTANCE = $this.xml.CHECKLIST.ASSET.WEB_DB_INSTANCE.ToUpper()
        $this.WEB_DB_SITE = $this.xml.CHECKLIST.ASSET.WEB_DB_SITE.ToUpper()
        $this.uniqueID = $this.HOST_NAME +"_"+ $this.stigid +"_"+ $this.WEB_DB_INSTANCE +"_" + $this.WEB_DB_SITE
        $this.ROLE = $this.xml.CHECKLIST.ASSET.ROLE
        $this.TECH_AREA = $this.xml.CHECKLIST.ASSET.TECH_AREA
        $this.TARGET_COMMENT = $this.xml.CHECKLIST.ASSET.TARGET_COMMENT
    }
    
    Checklist([System.Xml.XmlNode]$xmlData){
        $this.FileInfo = $null
        $this.xml = $xmlData
        $this.stigid = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("stigid")]
        $this.title = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("title")]
        $this.version = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("version")]
        $this.release = $this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_DATA[$this.xml.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA.SID_NAME.IndexOf("releaseinfo")]
        $this.release = $this.release.Replace("Release: ","")
        $this.release = $this.release -replace " Benc.*",""
        $this.AssetType = $this.xml.CHECKLIST.ASSET.ASSET_TYPE
        $this.HOST_NAME = $this.xml.CHECKLIST.ASSET.HOST_NAME.ToUpper()
        $this.HOST_IP = $this.xml.CHECKLIST.ASSET.HOST_IP
        $this.HOST_MAC = $this.xml.CHECKLIST.ASSET.HOST_MAC.ToUpper()
        $this.HOST_FQDN = $this.xml.CHECKLIST.ASSET.HOST_FQDN.ToUpper()
        $this.WEB_OR_DATABASE = $this.xml.CHECKLIST.ASSET.WEB_OR_DATABASE.ToLower()
        $this.WEB_DB_INSTANCE = $this.xml.CHECKLIST.ASSET.WEB_DB_INSTANCE.ToUpper()
        $this.WEB_DB_SITE = $this.xml.CHECKLIST.ASSET.WEB_DB_SITE.ToUpper()
        $this.uniqueID = $this.HOST_NAME +"_"+ $this.stigid +"_"+ $this.WEB_DB_INSTANCE +"_" + $this.WEB_DB_SITE
        $this.ROLE = $this.xml.CHECKLIST.ASSET.ROLE
        $this.TECH_AREA = $this.xml.CHECKLIST.ASSET.TECH_AREA
        $this.TARGET_COMMENT = $this.xml.CHECKLIST.ASSET.TARGET_COMMENT
    }

    [void] SetAssetInfo(){
        $this.SetHOSTNAME()
        $this.SetAssetType()
        $this.SetIP()
        $this.SetFQDN()
        $this.SetMAC()
        $this.SetROLE()
        $this.SetTechArea()
        $this.SetWDB()
        $this.SetDB()
        $this.SetInstance()
        $this.SetTargetComment()
    }
    [void] SetHOSTNAME(){
        $this.xml.CHECKLIST.ASSET.HOST_NAME = $this.HOST_NAME
    }
    [void] SetAssetType(){
        $this.xml.CHECKLIST.ASSET.ASSET_TYPE = $this.AssetType
    }
    [void] SetIP(){
        $this.xml.CHECKLIST.ASSET.HOST_IP = $this.HOST_IP
    }
    [void] SetFQDN(){
        $this.xml.CHECKLIST.ASSET.HOST_FQDN = $this.HOST_FQDN.ToUpper()
    }
    [void] SetMAC(){
        $this.xml.CHECKLIST.ASSET.HOST_MAC = $this.HOST_MAC.ToUpper()
    }
    [void] SetROLE(){
        $this.xml.CHECKLIST.ASSET.ROLE = $this.ROLE
    }
    [void] SetTechArea(){
        $this.xml.CHECKLIST.ASSET.TECH_AREA = $this.TECH_AREA
    }
    [void] SetWDB(){
        $this.xml.CHECKLIST.ASSET.WEB_OR_DATABASE = $this.WEB_OR_DATABASE
    }
    [void] SetDB(){
        $this.xml.CHECKLIST.ASSET.WEB_DB_SITE = $this.WEB_DB_SITE
    }
    [void] SetInstance(){
        $this.xml.CHECKLIST.ASSET.WEB_DB_INSTANCE = $this.WEB_DB_INSTANCE
    }
    [void] SetTargetComment(){
        $this.xml.CHECKLIST.ASSET.TARGET_COMMENT = $this.TARGET_COMMENT
    }
    [void] EmptyXML(){
        $this.xml.RemoveAll()
    }
    [void] AnalyzeVulns([System.Array]$SeverityOverrides){
        $This.AnalyzeVulns()
        #Needs to be cleaned up.
        #$this.VULNS =@()
        #ForEach($lclVuln in $this.xml.CHECKLIST.STIGS.iSTIG.VULN){
        #    [Vulnerability]$newVuln = [Vulnerability]::new($lclVuln)
        #    if($SeverityOverrides.VulnID.ToUpper() -contains $newVuln.VulnID.ToUpper()){
        #        $newVuln.SetOverride()
        #        $lclIndex = $SeverityOverrides.VulnID.ToUpper().IndexOf($newVuln.VulnID.ToUpper())
        #        $newVuln.SetKIORSection($SeverityOverrides[$lclIndex].KIoRSection)
        #        $newVuln.SetKIORSubSection($SeverityOverrides[$lclIndex].KIoRSubSection)

        #    }
        #    $this.VULNS.Add($newVuln)
        #}
    }
    [void] AnalyzeVulns(){
        $this.VULNS =@()
        ForEach($lclVuln in $this.xml.CHECKLIST.STIGS.iSTIG.VULN){
            [Vulnerability]$newVuln = [Vulnerability]::new($lclVuln)
            $this.VULNS.Add($newVuln)
        }
    }
}

class SCCXCCDF{
    [string]$stigid
    [string]$title
    [string]$version
    [string]$release
    [System.IO.FileSystemInfo]$FileInfo
    [System.Xml.XmlNode]$xml
    [string]$hash
    [string]$uniqueID
    [string]$HOST_NAME
    [string]$WEB_DB_INSTANCE
    [string]$WEB_DB_SITE
    [string]$ROLE
    [string]$TECH_AREA
    [string]$WEB_OR_DATABASE
    [string]$HOST_IP
    [string]$HOST_MAC
    [string]$HOST_FQDN
    [string]$TARGET_COMMENT
    [string]$AssetType
    [System.Collections.ArrayList]$VULNS = @()

    SCCXCCDF([string]$pathToXCCDF){
        $this.FileInfo = Get-ChildItem -Path $pathToXCCDF
        $this.xml = (Select-Xml -Path $this.FileInfo.FullName -XPath /).node
        $this.stigid = $this.xml.Benchmark.id -replace ".*benchmark_",""
        $this.title = $this.xml.Benchmark.title
        $this.version = $this.xml.Benchmark.version.'#text' -replace "\..*",""
        $this.release = $this.xml.Benchmark.version.'#text' -replace ".*\.",""
        $this.AssetType = ""
        $this.HOST_NAME = ($this.xml.Benchmark.TestResult.target).ToUpper()
        $this.HOST_IP = $this.xml.Benchmark.TestResult.'target-address'[0]
        $this.HOST_MAC = $this.xml.Benchmark.TestResult.'target-facts'.fact.'#text'[$this.xml.Benchmark.TestResult.'target-facts'.fact.name.IndexOf("urn:scap:fact:asset:identifier:mac")]
        $this.HOST_FQDN = $this.xml.Benchmark.TestResult.'target-facts'.fact.'#text'[$this.xml.Benchmark.TestResult.'target-facts'.fact.name.IndexOf("urn:scap:fact:asset:identifier:fqdn")]
        $this.uniqueID = $this.HOST_NAME +"_"+ $this.stigid +"_"+ $this.WEB_DB_INSTANCE +"_" + $this.WEB_DB_SITE
    }
    [void] AnalyzeVulns(){
        $this.VULNS =@()
        ForEach($lclVuln in $this.xml.Benchmark.TestResult.'rule-result'){
            $lclVulnID = ($lclVuln.idref -replace ".*stig_rule_S","") -replace "r.*"
            $lclRuleID = $lclVuln.idref -replace ".*stig_rule_",""
            $lclStatus = ""
            if($lclVuln.result -eq "pass"){
                $lclStatus = "NotAFinding"
            }
            elseif ($lclVuln.result -eq "fail") {
                $lclStatus = "Open"
            }
            elseif ($lclVuln.result -eq "notapplicable"){
                $lclStatus = "Not_Applicable"
            }

            $lclFindingDetails = $lclVuln.message.'#text'

            if($lclStatus -eq ""){
                #do nothing?
            }
            else{
                [Vulnerability]$newVuln = [Vulnerability]::new($lclVulnID,$lclStatus,$lclFindingDetails,$lclRuleID)
                $this.VULNS.Add($newVuln)
            }
            Remove-Variable lclVuln,lclRuleID,lclStatus,lclFindingDetails

        }
    }
}

class Vulnerability{
    [string]$VulnID
    [string]$Status
    [string]$FindingDetails
    [string]$Comments
    [string]$Severity
    [string]$RuleID
    [switch]$CCRIOverride
    [string]$KIoRSection
    [string]$KIoRSubSection
    [double]$points

    Vulnerability(){
        #basic constructer
    }
    Vulnerability([System.Xml.XmlElement]$VulnXML){
        $this.VulnID = $VulnXML.STIG_DATA.ATTRIBUTE_DATA[$VulnXML.STIG_DATA.VULN_ATTRIBUTE.IndexOf("Vuln_Num")]
        $this.Comments = $VulnXML.COMMENTS
        $this.Status = $VulnXML.STATUS
        $this.FindingDetails = $VulnXML.FINDING_DETAILS
        $this.Severity = $VulnXML.STIG_DATA.ATTRIBUTE_DATA[$VulnXML.STIG_DATA.VULN_ATTRIBUTE.IndexOf("Severity")]
        $this.RuleID = $VulnXML.STIG_DATA.ATTRIBUTE_DATA[$VulnXML.STIG_DATA.VULN_ATTRIBUTE.IndexOf("Rule_ID")]
        $this.points = 0
    }

    Vulnerability([string]$xVulnID,[string]$xStatus,[string]$xFindingDetails,[string]$xRuleID){
        $this.VulnID = $xVulnID
        $this.Status = $xStatus
        $this.FindingDetails = $xFindingDetails
        $this.RuleID = $xRuleID
    }

    [void] SetOverride(){
        $this.CCRIOverride = $true
    }
    [void] SetKIORSection([string]$KioR){
        $this.KIoRSection = $KioR
    }
    [void] SetKIORSubSection([string]$KioR){
        $this.KIoRSubSection = $KioR
    }
    [void] SetPOINTS([double]$PointSet){
        $this.points = $PointSet
    }
}

class TechAreas{
    [System.Collections.ArrayList]$mapping = @()
    
    TechAreas(){
        #region basic STIG to TECH AREA Mapping
        $this.mapping.Add([mappingTechArea]::new('A10_Networks_ADC_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('A10_Networks_ADC_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('AAA_Service_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Active_Directory_Domain','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Active_Directory_Forest','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Adobe_Acrobat_Pro_DC_Classic_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Adobe_Acrobat_Pro_DC_Continuous_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Adobe_Acrobat_Reader_DC_Continuous_Track_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Adobe_ColdFusion_11_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Airwatch_MDM_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Akamai_KSD_Service_IL2_ALG_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Akamai_KSD_Service_IL2_NDM_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Apache_Server_2-4_UNIX_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Apache_Server_2-4_UNIX_Site_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Apache_Server_2-4_Windows_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Apache_Server_2-4_Windows_Site_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('APACHE_SERVER_2.2_UNIX','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('APACHE_SERVER_2.2_WINDOWS','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('APACHE_SITE_2.2_UNIX','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('APACHE_SITE_2.2_WINDOWS','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS-iPadOS_15_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS-iPadOS_16_BYOAD_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS-iPadOS_16_COBO-COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS-iPadOS_16_MDFPP_3-3_BYOAD_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS-iPadOS_17_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_iOS_iPadOS_14_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Apple_macOS_11_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Apple_macOS_12_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Apple_macOS_13_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Apple_OS_X_10-15_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Application_Layer_Gateway_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Application_Security_Development_STIG','Application Review'))
        $this.mapping.Add([mappingTechArea]::new('Application_Server_SRG','Application Review'))
        $this.mapping.Add([mappingTechArea]::new('ArcGIS_Server_10-3_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Arista_DCS-7000_Series_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Arista_DCS-7000_Series_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Arista_DCS-7000_Series_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Arista_MLS_EOS_4-2x_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Arista_MLS_EOS_4-2x_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Arista_MLS_EOS_4-2x_Router_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('AvePoint_Compliance_Guardian_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('AvePoint_DocAve_6_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('AvePoint_DocAve_6_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('BB_CylancePROTECT_Mobile_for_UEM_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('BB_UEM_MDM_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('BEMS_2-x_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('BEMS_3-x_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Bind_9-x_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Canonical_Ubuntu_20-04_LTS_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('CAN_Ubuntu_18-04_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('CA_API_Gateway_ALG_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('CA_API_Gateway_NDM_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('CA_IDMS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Central_Log_Server_SRG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ASA_FW_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ASA_IPS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ASA_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ASA_VPN_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS-XE_Router_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS-XE_Router_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS-XR_Router_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS-XR_Router_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_Router_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_Router_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_Switch_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_Switch_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_Switch_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_XE_Switch_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_IOS_XE_Switch_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ISE_NAC_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_ISE_NDM_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_NX-OS_Switch_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Cisco_NX-OS_Switch_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7-x_Delivery_Controller_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7-x_License_Server_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7-x_Linux_VDA_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7-x_StoreFront_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7-x_Workspace_App_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_VAD_7x_Windows_VDA_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_XenDesktop_7-x_Receiver_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_XenDesktop_7-x_Windows_VDA_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_XenDesktop_Delivery_Controller_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_XenDesktop_License_Server_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Citrix_XenDesktop_StoreFront_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Cloud_Computing_Mission_Owner_SRG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('CMD_Policy_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Container_Platform_SRG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Crunchy_Data_PostgreSQL_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Database_Generic','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('DB_Networks_DBN_6300_IDPS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('DB_Networks_DBN_6300_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('DNS_Policy','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('DNS_SRG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Docker_Enterprise_2-x_Linux-UNIX_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('EDB_Postgres_Advanced_Server_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('EDB_Postgres_Advanced_Server_v11_on_Windows_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Enclave_-_Zone_A','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Enclave_-_Zone_B','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Enclave_-_Zone_C','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Enclave_-_Zone_D','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_-_Policy','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_Client_Access_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_Edge_Transport_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_Edge_Transport_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_Hub_Transport_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('Exchange_2010_Mailbox_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('F5_BIG-IP_Access_Policy_Manager_11-x_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('F5_BIG-IP_Advanced_Firewall_Manager_11.x_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('F5_BIG-IP_Application_Security_Manager_11.x_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('F5_BIG-IP_Device_Management_11-x_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('F5_BIG-IP_Local_Traffic_Manager_11-x_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Firewall_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('FN_FortiGate_Firewall_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('FN_FortiGate_Firewall_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('ForeScout_CounterACT_ALG_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('ForeScout_CounterACT_NDM_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Forescout_NDM_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('FS_NAC_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('General_Purpose_Operating_System','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_12_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_12_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_13_BYOAD_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_13_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_13_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_13_MDF_PP_3-3_BYOAD_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_14_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Android_14_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Google_Chrome_Current_Windows','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Google_Search_Applicance_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPE_3PAR_SSMC_GPOS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPE_3PAR_SSMC_WS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPE_3PAR_StoreServ_3.2.x_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPE_3PAR_StoreServ_3.3.x_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPE_Nimble_Storage_Array_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('HPUX_11.31_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('HP_FlexFabric_Switch_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('HP_FlexFabric_Switch_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('HP_FlexFabric_Switch_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('HW_Android_9-x_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('HW_Android_9-x_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('HYCU_for_Nutanix_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_AIX_7-x_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('IBM_Aspera_Platform_4-2_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_Aspera_Platform_4-2_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_DataPower_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_DataPower_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_DB2_V10-5_LUW_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_Hardware_Management_Console_Policies','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_HMC_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_MaaS360_with_Watson_v10.x_MDM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_MQ_Appliance_V9-0_AS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_MQ_Appliance_v9-0_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IBM_WebSphere_Liberty_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_WebSphere_Traditional_V9-x_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('IBM_zOS_ACF2_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('IBM_zOS_RACF_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('IBM_zOS_TSS_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('IBM_zVM_CA_VMSecure_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('IDPS_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('IE_11_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('IIS_10-0_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('IIS_10-0_Site_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('IIS_8-5_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('IIS_8-5_Site_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Infoblox_7-x_DNS_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Infoblox_8_DNS_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('ISEC7_Sphere','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('ISEC_EMM_Suite_v6-x_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Ivanti_MI_Core_MDM_Server_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Ivanti_MI_Sentry_9-x_ALG_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Ivanti_MI_Sentry_9-x_NDM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Jamf_Pro_v10-x_EMM_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('JBoss_EAP_6-3_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_EX_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_EX_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_EX_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_Router_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_Router_RTR_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_SRX_SG_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_SRX_SG_IDPS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_SRX_SG_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Juniper_SRX_SG_VPN_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Kubernetes_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Layer_2_Switch_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Mainframe_Product_SRG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('MariaDB_Enterprise_10-x_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MarkLogic_Server_v9_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('McAfee_Application_Control_7-x_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('McAfee_Application_Control_8-x_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('McAfee_VSEL_1-9_2-0_Local_Client_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('McAfee_VSEL_1-9_2-0_Managed_Client_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('McAfee_VSEL_1-9_2-0_Managed_Client_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('MDM_Server_Policy__STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Access_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Access_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Access_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Excel_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Excel_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Excel_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Groove_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_InfoPath_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_InfoPath_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Lync_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Office_System_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Office_System_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Office_System_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_OneDrive_for_Business_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_OneDrive','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_OneNote_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_OneNote_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_OneNote_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Outlook_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Outlook_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Outlook_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_PowerPoint_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_PowerPoint_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_PowerPoint_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Project_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Project_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Project_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Publisher_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Publisher_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Publisher_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_SharePoint_Designer_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_SharePoint_Server_2013','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Skype_for_Business_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Visio_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Visio_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Windows_10_Mobile_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Windows_11_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Windows_2012_Server_Domain_Name_System_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Word_2010','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Word_2013','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Microsoft_Word_2016','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MobileIron_Core_v10-x_MDM_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Mobile_Device_Policy_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('MongoDB_3-x_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MongoDB_Enterprise_Advanced_4-x_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MOT_Android_9-x_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('MOT_Android_9-x_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('MOZ_Firefox_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_Android_11_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('MS_Android_11_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('MS_Azure_SQL_DB_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MS_Defender_Antivirus','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('MS_Dot_Net_Framework','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_Edge_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_Exchange_2013_CAS_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('MS_Exchange_2013_Edge_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('MS_Exchange_2013_Mailbox_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('MS_Exchange_2016_Edge_Transport_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('MS_Exchange_2016_Mailbox_Server_STIG','Exchange Server'))
        $this.mapping.Add([mappingTechArea]::new('MS_Office_365_ProPlus_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_SCOM_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_SQL_Server_2014_Database_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MS_SQL_Server_2014_Instance_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MS_SQL_Server_2016_Database_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MS_SQL_Server_2016_Instance_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('MS_Windows_10_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MS_Windows_Server_2022_DNS_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('MS_Windows_Server_2022_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('MULTI-FUNCTION_DEVICE','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('NetApp_ONTAP_DSC_9-x_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Network_Device_Management_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Network_Infrastructure_Policy_STIG','Boundary Security'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_AP-IG_Mgmt_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_AP-IG_Platform_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_AP-NIPR_Mgmt_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_AP-NIPR_Platform_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_Bridge_Mgmt_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_Bridge_Platform_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_Controller_Mgmt_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Network_WLAN_Controller_Platform_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Nutanix_AOS_5-20-x_Application_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Nutanix_AOS_5-20-x_OS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Database_11-2g_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Database_11g_Installation_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Database_11g_Instance_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Database_12c_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_HTTP_Server_12-1-3_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Linux_6_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Linux_7_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_Linux_8_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_MySQL_8.0_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Oracle_WebLogic_Server_12c_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Palo_Alto_Networks_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Palo_Alto_Networks_IDPS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Palo_Alto_Networks_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('PAN_Prisma_Cloud_Compute_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('PostgreSQL_9-x_STIG','Database Review'))
        $this.mapping.Add([mappingTechArea]::new('Rancher_MCM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('RB_NetProfiler_STIG','Application Review'))
        $this.mapping.Add([mappingTechArea]::new('Redis_Enterprise_6-x_STIG','Application Review'))
        $this.mapping.Add([mappingTechArea]::new('RGS_RKE2_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('RHEL_6_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('RHEL_7_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('RHEL_8_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('RHEL_9_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('RH_Ansible_Automation_Controller_App_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('RH_Ansible_Automation_Controller_Web_Server_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('RH_OpenShift_Container_Platform_4-12_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Riverbed_Steelhead_CX_v8_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Riverbed_SteelHead_CX_V8_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Router_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Samsung_Android_10_Knox_3-x_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Samsung_SDS_EMM_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SAN','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('SDN_Controller_SRG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('SDN_NV_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('SEL-2740S_L2S_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('SEL-2740S_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('SLES_12_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('SLES_15_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Solaris_10_SPARC_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Solaris_10_x86','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Solaris_11_SPARC_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Solaris_11_X86_STIG','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('SPEC_Innovations_Innoslate_4.x_STIG','Application Review'))
        $this.mapping.Add([mappingTechArea]::new('Splunk_Enterprise_7-x_for_Windows_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Splunk_Enterprise_8-x_for_Linux_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_11_Knox_3-x_AE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_11_Knox_3-x_Legacy_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_12_KPE_3-x_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_12_KPE_3-x_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_OS_13_KPE_3-x_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SS_Android_OS_13_KPE_3-x_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('SuSe_zLinux','UNIX OS'))
        $this.mapping.Add([mappingTechArea]::new('Symantec_ProxySG_ALG_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Symantec_ProxySG_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Tanium_7-x_Application_TanOS_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Tanium_7-x_OS_TanOS_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Tanium_7-x_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Tanium_7.0_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Tanium_7.3_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('TM_TippingPoint_IDPS_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('TM_TippingPoint_NDM_STIG','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('Tomcat_Application_Server_9_STIG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('TOSS_4_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Trend_Micro_Deep_Security_9-x_STIG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('UC_Endpoint_SRG','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('UC_Session_Management_SRG','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('UEM_Agent_SRG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('UEM_Server_SRG','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('VMM','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_Horizon_7-13_Agent_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_Horizon_7-13_Client_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_Horizon_7-13_Connection_Server_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_NSX-T_Distributed_FW_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_NSX-T_SDN_Controller_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_NSX_Distributed_Logical_Router_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_NSX_Manager_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_vSphere_6-5_ESXi_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_vSphere_6-5_vCenter_Server_for_Windows_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_vSphere_6-5_Virtual_Machine_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMware_Workspace_ONE_UEM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_AW_v9-x_MDM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_NSX-T_Manager_NDM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_NSX-T_T-0_Gateway_FW_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_NSX-T_T-0_RTR_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_NSX-T_T1_Gateway_FW_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_NSX-T_T1_Gateway_RTR_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_Application_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_HA_Proxy_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_Lighttpd_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_PostgreSQL_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_SLES_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_tcServer_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_VAMI_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Automation_7-x_vIDM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Operations_Manager_6-x_Application_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Operations_Manager_6-x_PostgreSQL_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Operations_Manager_6-x_SLES_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vRealize_Operations_Manager_6-x_tcServer_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_EAM_Tomcat_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_ESXi_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_Perfcharts_Tomcat_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_Photon_OS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_PostgreSQL_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_RhttpProxy_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_STS_Tomcat_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_UI_Tomcat_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_VAMI-lighttpd_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_vCenter_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_Virgo-Client_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_6-7_Virtual_Machine_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_ESXi_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_VAMI_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_EAM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_Lookup_Svc_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_Perfcharts_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_Photon_OS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_PostgreSQL_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_RhttpProxy_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_STS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCA_UI_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_vCenter_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_7-0_Virtual_Machine_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_ESXi_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_vCenter_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_EAM_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_Envoy_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_Lookup_Svc_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_Perfcharts_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_Photon_OS_4-0_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_PostgreSQL_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_STS_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_UI_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8-0_VCSA_VAMI_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('VMW_vSphere_8.0_Virtual_Machine_STIG','Other Review'))
        $this.mapping.Add([mappingTechArea]::new('Voice_Video_Endpoint','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('Voice_Video_Session_Management','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('VPN','Internal Network'))
        $this.mapping.Add([mappingTechArea]::new('VTC_Policy','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('VVoIP_STIG_Policy','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('VVOIP_Technical','VVOIP Review'))
        $this.mapping.Add([mappingTechArea]::new('Web_Server_SRG','Web Review'))
        $this.mapping.Add([mappingTechArea]::new('Windows_2012_DC_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Windows_2012_MS_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Windows_Firewall_with_Advanced_Security','Host Based System Security (HBSS)'))
        $this.mapping.Add([mappingTechArea]::new('Windows_PAW_STIG','Domain Name System (DNS)'))
        $this.mapping.Add([mappingTechArea]::new('Windows_Server_2016_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Windows_Server_2019_STIG','Windows OS'))
        $this.mapping.Add([mappingTechArea]::new('Zebra_Android_10_COBO_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Zebra_Android_10_COPE_STIG','Mobility'))
        $this.mapping.Add([mappingTechArea]::new('Zebra_Android_11_COBO_STIG','Mobility'))
        #endregion
    }

}

class mappingTechArea{
    [string]$STIGID
    [string]$TECH_AREA

    mappingTechArea([string]$xSTIGID,[string]$xTECH_AREA){
        $this.STIGID = $xSTIGID
        $this.TECH_AREA =$xTECH_AREA
    }
}

class STIG{
    [string]$stigid
    hidden [string]$TECH_AREA
    [string]$WEB_OR_DATABASE
    [string]$WEB_DB_SITE
    [string]$WEB_DB_INSTANCE
    [string]$uniqueID

    STIG(){}
    STIG(
        [string]$lclID,
        [string]$lclTechArea = "",
        [string]$lclWorD = "false",
        [string]$lclSite = "",
        [string]$lclInstance = ""
    ){
        $this.stigid = $lclID
        $this.TECH_AREA = $lclTechArea
        $this.WEB_OR_DATABASE = $lclWorD
        $this.WEB_DB_SITE = $lclSite
        $this.WEB_DB_INSTANCE = $lclInstance
    }

    [void]GenerateUniqueID([string]$providedHostName){
        $this.uniqueID = $providedHostName + "_" + $this.stigid +"_"+ $this.WEB_DB_INSTANCE + "_"+ $this.WEB_DB_SITE
    }
   
}

class Asset{
    [string]$ROLE
    [string]$ASSET_TYPE
    [string]$HOST_NAME
    [string]$HOST_IP
    [string]$HOST_MAC
    [string]$HOST_FQDN
    [string]$TARGET_COMMENT
    [string]$TECH_AREA
    [switch]$Inactive
    [System.Collections.ArrayList]$STIGS = @()
    Asset(){}
    Asset(
        [string]$lclRole,
        [string]$lclAssetType,
        [string]$lclHostName,
        [string]$lclHostIP,
        [string]$lclHostMac,
        [string]$lclHostFQDN,
        [string]$lclTargetComment,
        [string]$lclTechArea
    ){
        $this.ROLE = $lclRole
        $this.ASSET_TYPE = $lclAssetType
        $this.HOST_NAME = $lclHostName.ToUpper()
        $this.HOST_IP = $lclHostIP
        $this.HOST_MAC = $lclHostMac.ToUpper()
        $this.HOST_FQDN = $lclHostFQDN.ToUpper()
        $this.TARGET_COMMENT = $lclTargetComment
        $this.TECH_AREA = $lclTechArea
    }  
    [void]AddSTIG([string]$STIGID,[string]$TECH_AREA,[string]$WEB_OR_DATABASE,[string]$WEB_DB_SITE,[string]$WEB_DB_INSTANCE){
        [STIG]$newSTIG = ([STIG]::new($STIGID,$TECH_AREA,$WEB_OR_DATABASE,$WEB_DB_SITE,$WEB_DB_INSTANCE))
        $newSTIG.GenerateUniqueID($this.HOST_NAME)
        ##Check to see if it is already mapped!
        if($this.STIGS.UniqueID -contains $newSTIG.uniqueID){
            #already have STIG mapped to asset
        }
        else{
            $this.STIGS.Add($newSTIG)

        }

        
    }
    [void]RemoveSTIG([string]$unID){
        [int]$tempIndex = $This.STIGS.uniqueID.indexof($unID)
        #This should return a -1 if it is not in the index.  This is CASE Sensitive.
        if($tempIndex -ge 0){$this.STIGS.RemoveAt($tempIndex)}
       
    }
    [void]SetIP([string]$newIP){
        $this.HOST_IP = $newIP
    }
    [void]SetMAC([string]$newMAC){
        $this.HOST_MAC = $newMAC
    }
    [void]SetFQDN([string]$newFQDN){
        $this.HOST_FQDN = $newFQDN
    }
    [void]SetROLE([string]$newRole){
        if(($newRole -eq "") -or ($newRole -eq "Workstation") -or ($newRole -eq "Member Server") -or ($newRole -eq "Domain Controller")){
            $this.ROLE = $newRole
        }
    }
    [void]SetTECHAREA([string]$newTA){
        if(($newTA -eq "") -or ($newTA -eq "Application Review") -or ($newTA -eq "Boundary Security") -or ($newTA -eq "CDS Admin Review") -or ($newTA -eq "CDS Technical Review") -or ($newTA -eq "Database Review") -or ($newTA -eq "Domain Name System (DNS)") -or ($newTA -eq "Exchange Server") -or ($newTA -eq "Host Based System Security (HBSS)") -or ($newTA -eq "Internal Network") -or ($newTA -eq "Mobility") -or ($newTA -eq "Releasable Networks (REL)") -or ($newTA -eq "Traditional Security") -or ($newTA -eq "UNIX OS") -or ($newTA -eq "VVOIP Review") -or ($newTA -eq "Web Review") -or ($newTA -eq "Windows OS") -or ($newTA -eq "Other Review")){
            $this.TECH_AREA = $newTA
        }
    }
    [void]SetCOMMENT([string]$newComment){
        $this.TARGET_COMMENT = $newComment
    }
    [void]FlipInactive(){
        if($this.Inactive){
            $this.Inactive = $false
        }
        else{
            $this.Inactive = $true
        }
    }
    [void]Stroll([System.Collections.ArrayList]$lclTemplates){
        [System.Collections.ArrayList]$CKLS = @()
        $PathToCurrent = $PWD.ToString() + "\current\" + $this.HOST_NAME
        If($this.Inactive){
            #Asset is currently INACTIVE.  Remove current contents.
            if(Test-Path -Path $PathToCurrent){
                #$CKLList = Get-ChildItem -Path $PathToCurrent -Include *.ckl -Recurse
                #ForEach($cklFile in $CKLList){
                #    Remove-Item -Path $cklFile.FullName
                #}
                #
                #Archive the asset
                $DestinationPath = $PWD.ToString() + "\archive\" + $this.HOST_NAME
                Compress-Archive -Path $PathToCurrent -DestinationPath $DestinationPath -CompressionLevel Optimal
                Remove-Item $PathToCurrent -Recurse
            }


        }
        else{
            
            #Asset is ACTIVE.  Check for and create Checklists.
            $PathToCurrent = $PWD.ToString() + "\current\" + $this.HOST_NAME
            If(Test-Path -Path $PathToCurrent){
                #Path to CURRENT Asset folder exists.  
            }
            else{
                #Path to CURRENT Asset folder does not exist,  create it.
                New-Item -ItemType Directory -Path $PathToCurrent

            }
            #Path now exists, find the checklists and load into memory (only once per asset - this will get slow..)
            $CKLFiles = Get-ChildItem -Path $PathToCurrent -Include *.ckl -Recurse
            
            ForEach($CKLFile in $CKLFiles){
                [Checklist]$newChecklist = [Checklist]::new($CKLFile.fullname)
                $CKLS.Add($newChecklist)
            }
            
            #Now the existing checklists are in memory, so we loop thru what SHOULD be there per the STIG to asset mapping (Forward Looks)
            if($CKLS.Count -gt 0){
                #There is at least 1 CKL to check
                ForEach($stig in $this.STIGS){

                    if($CKLS.uniqueID.ToUpper().Contains($stig.uniqueID.ToUpper())){
                        #Checklist exists. - Check the CKL Information?
                        $AnyChanges = $false
                        $tempINDEX = $CKLS.uniqueID.ToUpper().indexof($stig.uniqueID.ToUpper())
                        if($tempINDEX -ge 0){
                            #Check the CKL Version against the Template folder, update to CKL in Template folder if not matched.
                            $templateIndex = $lclTemplates.stigid.indexof($CKLS[$tempINDEX].stigid)
                            $VRMismatch = $false
                            if($templateIndex -ge 0){                                
                                if($lclTemplates[$templateIndex].version -ne $CKLS[$tempINDEX].version){$VRMismatch = $true}
                                if($lclTemplates[$templateIndex].release -ne $CKLS[$tempINDEX].release){$VRMismatch = $true}                 
                            }
                            if($VRMismatch){
                                Write-Host "Version / Release mismatch on " $stig.uniqueID.toUpper()
                                [Checklist]$newChecklist = [Checklist]::new($lclTemplates[$templateIndex].FileInfo.Fullname)
                                $newChecklist.HOST_NAME = $this.HOST_NAME
                                $newChecklist.SetHOSTNAME()
                                $newChecklist.HOST_IP = $this.HOST_IP
                                $newChecklist.SetIP()
                                $newChecklist.HOST_FQDN = $this.HOST_FQDN
                                $newChecklist.SetFQDN()
                                $newChecklist.HOST_MAC = $this.HOST_MAC
                                $newChecklist.SetMAC()
                                $newChecklist.ROLE = $this.ROLE
                                $newChecklist.SetROLE()
                                if($this.TECH_AREA -ne ""){
                                    $newChecklist.TECH_AREA = $this.TECH_AREA
                                    $newChecklist.SetTechArea()
                                }
                                $newChecklist.WEB_OR_DATABASE = $stig.WEB_OR_DATABASE.tolower()
                                $newChecklist.SetWDB()
                                $newChecklist.WEB_DB_SITE = $stig.WEB_DB_SITE
                                $newChecklist.SetDB()
                                $newChecklist.WEB_DB_INSTANCE = $stig.WEB_DB_INSTANCE
                                $newChecklist.SetInstance()
                                $newChecklist.TARGET_COMMENT = $this.TARGET_COMMENT
                                $newChecklist.SetTargetComment()
                                $tempVR = "v" + $newChecklist.version.ToString() + "r" + $newChecklist.release
                                
                                $tempFileName = Resize-CKLFileName -HOST_NAME $newChecklist.HOST_NAME -stigID $newChecklist.stigid -DBSite $newChecklist.WEB_DB_SITE -DBInstance $newChecklist.WEB_DB_INSTANCE -vr $tempVr -fileExtension ".ckl" -MaxFileLength 75
                                #Update VulnInfo
                                [stroll]$tempSTROLL=[stroll]::new($true)
                                $newChecklist.xml = $tempSTROLL.Import_Checklist($false,$false,$CKLS[$tempINDEX].xml,$newChecklist.xml)
                                $savetoPAth = $PathToCurrent + "\" + $tempFileName
                                $newChecklist.xml.Save($savetoPAth)
                                Write-Host $tempFileName
                                #Remove old checklist

                                Remove-Item -Path $CKLS[$tempINDEX].FileInfo.FullName
                                Remove-Variable tempFileName,tempSTROLL

                            }
                            else{
                                #If the versions match, then check the host information
                                #checkIP
                                If($CKLS[$tempINDEX].HOST_IP -ne $this.HOST_IP){
                                    $CKLS[$tempINDEX].HOST_IP = $this.HOST_IP
                                    $CKLS[$tempINDEX].SetIP()
                                    $AnyChanges = $true
                                }
                                #checkMAC
                                If($CKLS[$tempINDEX].HOST_MAC -ne $this.HOST_MAC){
                                    $CKLS[$tempINDEX].HOST_MAC = $this.HOST_MAC
                                    $CKLS[$tempINDEX].SetMAC()
                                    $AnyChanges = $true
                                }
                                #checkFQDN
                                If($CKLS[$tempINDEX].HOST_FQDN -ne $this.HOST_FQDN){
                                    $CKLS[$tempINDEX].HOST_FQDN = $this.HOST_FQDN
                                    $CKLS[$tempINDEX].SetFQDN()
                                    $AnyChanges = $true
                                }

                                #checkROLE
                                If($CKLS[$tempINDEX].ROLE -ne $this.ROLE){
                                    $CKLS[$tempINDEX].ROLE = $this.ROLE
                                    $CKLS[$tempINDEX].SetROLE()
                                    $AnyChanges = $true
                                }

                                #checkTechArea
                                If($this.TECH_AREA -eq "" -or $this.TECH_AREA -eq $null){
                                    #Do nothing since TechArea is not being forced.
                                } 
                                ElseIf($CKLS[$tempINDEX].TECH_AREA -ne $this.TECH_AREA){
                                    $CKLS[$tempINDEX].TECH_AREA = $this.TECH_AREA
                                    $CKLS[$tempINDEX].SetTechArea()
                                    $AnyChanges = $true
                                }
                                #checkComment
                                If($CKLS[$tempINDEX].TARGET_COMMENT -ne $this.TARGET_COMMENT){
                                    $CKLS[$tempINDEX].TARGET_COMMENT = $this.TARGET_COMMENT
                                    $CKLS[$tempINDEX].SetTargetComment()
                                    $AnyChanges = $true
                                }
                            }
                            Remove-Variable VRMismatch, templateIndex
                        }
                        else{
                            $tempERROR = "Issue checking STIG Information - " + $stig.uniqueID.ToUpper()
                            Write-Error -Message $tempERROR
                            Remove-Variable tempError
                        }


                        if($AnyChanges){
                            #Change Detected,  Save new CKL and remove old.
                            $tempVR = "v" + $CKLS[$tempINDEX].Version.ToString() + "r" + $CKLS[$tempINDEX].Release.ToString()
                            $tempFileName = Resize-CKLFileName -HOST_NAME $this.HOST_NAME -stigID $CKLS[$tempINDEX].stigid -DBSite $CKLS[$tempINDEX].WEB_DB_SITE -DBInstance $CKLS[$tempINDEX].WEB_DB_INSTANCE -vr $tempVR -fileExtension ".ckl" -MaxFileLength 75
                            $savetoPAth = $PathToCurrent + "\" + $tempFileName
                            $CKLS[$tempINDEX].xml.save($savetoPAth)
                            Write-Host "Updated " $tempFileName
                            Remove-Item -Path $CKLS[$tempINDEX].FileInfo.FullName
                            Remove-Variable tempVR, tempFileName,savetoPAth
                        }
                        Remove-Variable AnyChanges,tempINDEX

                    }
                    else{
                        #Checklist does not exist.  See if there is a template for it.
                        if($lclTemplates.stigid.Contains($stig.stigid)){
                            #Template Exists
                            [checklist]$newChecklist =[Checklist]::new($lclTemplates[$lclTemplates.stigid.indexof($stig.stigid)].FileInfo.Fullname)
                            $newChecklist.HOST_NAME = $this.HOST_NAME
                            $newChecklist.SetHOSTNAME()

                            $newChecklist.HOST_IP = $this.HOST_IP
                            $newChecklist.SetIP()

                            $newChecklist.HOST_FQDN = $this.HOST_FQDN
                            $newChecklist.SetFQDN()

                            $newChecklist.HOST_MAC = $this.HOST_MAC
                            $newChecklist.SetMAC()

                            $newChecklist.ROLE = $this.ROLE
                            $newChecklist.SetROLE()

                            if($this.TECH_AREA -ne ""){
                                $newChecklist.TECH_AREA = $this.TECH_AREA
                                $newChecklist.SetTechArea()
                            }

                            $newChecklist.WEB_OR_DATABASE = $stig.WEB_OR_DATABASE.tolower()
                            $newChecklist.SetWDB()

                            $newChecklist.WEB_DB_SITE = $stig.WEB_DB_SITE
                            $newChecklist.SetDB()

                            $newChecklist.WEB_DB_INSTANCE = $stig.WEB_DB_INSTANCE
                            $newChecklist.SetInstance()

                            $newChecklist.TARGET_COMMENT = $this.TARGET_COMMENT
                            $newChecklist.SetTargetComment()

                            $tempVR = "v" + $newChecklist.version.ToString() + "r" + $newChecklist.release
                            $tempFileName = Resize-CKLFileName -HOST_NAME $newChecklist.HOST_NAME -stigID $newChecklist.stigid -DBSite $newChecklist.WEB_DB_SITE -DBInstance $newChecklist.WEB_DB_INSTANCE -vr $tempVr -fileExtension ".ckl" -MaxFileLength 75
                        
                            $savetoPAth = $PathToCurrent + "\" + $tempFileName
                            $newChecklist.xml.Save($savetoPAth)
                            Write-Host $tempFileName

                        }
                        else{
                            #Template does not exist
                            Write-Host $stig.uniqueID "No Template"
                            pause
                        }
                    }
                }
                
            }
            else{
                #There are no CKLs, so make them all.
                ForEach($stig in $this.STIGS){
                    if($lclTemplates.stigid.Contains($stig.stigid)){
                        #template exists - make the checklist.
                        [checklist]$newChecklist =[Checklist]::new($lclTemplates[$lclTemplates.stigid.indexof($stig.stigid)].FileInfo.Fullname)
                        $newChecklist.HOST_NAME = $this.HOST_NAME
                        $newChecklist.SetHOSTNAME()

                        $newChecklist.HOST_IP = $this.HOST_IP
                        $newChecklist.SetIP()

                        $newChecklist.HOST_FQDN = $this.HOST_FQDN
                        $newChecklist.SetFQDN()

                        $newChecklist.HOST_MAC = $this.HOST_MAC
                        $newChecklist.SetMAC()

                        $newChecklist.ROLE = $this.ROLE
                        $newChecklist.SetROLE()

                        if($this.TECH_AREA -ne ""){
                            $newChecklist.TECH_AREA = $this.TECH_AREA
                            $newChecklist.SetTechArea()
                        }

                        $newChecklist.WEB_OR_DATABASE = $stig.WEB_OR_DATABASE.tolower()
                        $newChecklist.SetWDB()

                        $newChecklist.WEB_DB_SITE = $stig.WEB_DB_SITE
                        $newChecklist.SetDB()

                        $newChecklist.WEB_DB_INSTANCE = $stig.WEB_DB_INSTANCE
                        $newChecklist.SetInstance()

                        $newChecklist.TARGET_COMMENT = $this.TARGET_COMMENT
                        $newChecklist.SetTargetComment()

                        $tempVR = "v" + $newChecklist.version.ToString() + "r" + $newChecklist.release
                        $tempFileName = Resize-CKLFileName -HOST_NAME $newChecklist.HOST_NAME -stigID $newChecklist.stigid -DBSite $newChecklist.WEB_DB_SITE -DBInstance $newChecklist.WEB_DB_INSTANCE -vr $tempVr -fileExtension ".ckl" -MaxFileLength 75
                        
                        $savetoPAth = $PathToCurrent + "\" + $tempFileName
                        $newChecklist.xml.Save($savetoPAth)
                        Write-Host $tempFileName
                    }
                    else{
                        #template does not exist - warn user
                        Write-Host "Template does not exist" $stig.uniqueID
                        pause
                    }
                }
            }
            #Reverse lookup time,  Make sure that the only CKLs posted for an asset are expected ones.
            [System.Collections.ArrayList]$CKLS = @()
            $CKLFiles = Get-ChildItem -Path $PathToCurrent -Include *.ckl -Recurse
            ForEach($CKLFile in $CKLFiles){
                [Checklist]$newChecklist = [Checklist]::new($CKLFile.fullname)
                $CKLS.Add($newChecklist)
            }

        
            if($CKLS.Count -gt 0){
                ForEach($ckl in $CKLS){
                    if($this.STIGS.uniqueID.ToUpper().Contains($ckl.uniqueID.ToUpper())){
                        #Discovered Checklist is in the correct folder.
                    }
                    else{
                        #Should not happen unless someone removed a STIG from memory OR added a ckl that shouldnt be there.
                        Write-Host "Found issue at " $ckl.FileInfo.FullName
                        Remove-Item -Path $ckl.fileInfo.Fullname 
                    }
                }

            }

        }
        
    }
    
}

class AssetList{
    [System.Collections.ArrayList]$Assets = @()
    [System.Collections.ArrayList]$importedAssets = @()
    [xml]$xml
    [System.IO.FileSystemInfo]$FileInfo
    #need to figure out JSON piece here.

    [void]AddAsset([string]$lclRole,[string]$lclAssetType,[string]$lclHostName,[string]$lclHostIP,[string]$lclHostMac,[string]$lclHostFQDN,[string]$lclTargetComment,[string]$lclTechArea){
        [Asset]$newAsset = [Asset]::new($lclRole,$lclAssetType,$lclHostName,$lclHostIP,$lclHostMAC,$lclHostFQDN,$lclTargetComment,$lclTechArea)
        if($this.Assets.HOST_NAME -contains $lclHostName){
            #just make sure you are not adding a duplicate asset.  This may need to be removed
        }
        Else{
            $this.Assets.Add($newAsset)
        }
        
    }
    [void]RemoveAsset([string]$HOST_NAME){
        $HOST_NAME = $HOST_NAME.ToUpper()
        if($this.Assets.HOST_NAME -contains $HOST_NAME){
            $this.Assets.RemoveAt($this.Assets.HOST_NAME.indexof($HOST_NAME))
        }
        else{
        }
    }
    [void] ManualAddAsset(){
        
        Clear-Host
        [Asset]$newAsset = [Asset]::new()
        $newAsset.HOST_NAME = Read-Host "Enter the HOST_NAME"
        $newAsset.HOST_IP = Read-Host "Enter the HOST_IP"
        $newAsset.HOST_MAC = Read-Host "Enter the HOST_MAC"
        $newAsset.HOST_FQDN = Read-Host "Enter the HOST_FQDN"
        Write-Host "--Asset Type--"
        Write-Host "[1]  Computing"
        Write-Host "[2]  Non-Computing"
        $selection = Read-Host "Select an Asset Type (Default: Computing)"
        if($selection -eq "2"){$newAsset.ASSET_TYPE = "Non-Computing"}
        else{$newAsset.ASSET_TYPE = "Computing"}
        Write-Host ""
        Write-Host "--Roles--"
        Write-Host "[1]  None"
        Write-Host "[2]  Workstation"
        Write-Host "[3]  Member Server"
        Write-Host "[4]  Domain Controller"
        $selection = Read-Host "Select an Asset Role (Default: None)"
        switch($selection){
            "2" {$newAsset.ROLE = "Workstation"}
            "3" {$newAsset.ROLE = "Member Server"}
            "4" {$newAsset.ROLE = "Domain Controller"}
            default {$newAsset.ROLE = "None"}
        }
        $newAsset.TARGET_COMMENT = Read-Host "Enter a target comment (Suggest the SysAdmin Name / Org)"
        Write-Host ""
        Write-Host "--Technology Area--"
        Write-Host "[a]  None"
        Write-Host "[b]  Application Review"
        Write-Host "[c]  Boundary Security"
        Write-Host "[d]  CDS Admin Review"
        Write-Host "[e]  CDS Technical Review"
        Write-Host "[f]  Database Review"
        Write-Host "[g]  Domain Name System (DNS)"
        Write-Host "[h]  Exchange Server"
        Write-Host "[i]  Host Based System Security (HBSS)"
        Write-Host "[j]  Internal Network"
        Write-Host "[k]  Mobility"
        Write-Host "[l]  Releasable Networks (REL)"
        Write-Host "[m]  Traditional Security"
        Write-Host "[n]  UNIX OS"
        Write-Host "[o]  VVOIP Review"
        Write-Host "[p]  Web Review"
        Write-Host "[q]  Windows OS"
        Write-Host "[r]  Other Review"
        Write-Host ""
        Write-Host "This will FORCE every associated STIG to this asset to be considered part of this technology area."
        $selection = Read-Host "Select which technology area to associate this asset (Default = None)"
        switch($selection){
            "a"{$newAsset.TECH_AREA = ""}
            "b"{$newAsset.TECH_AREA = "Application Review"}
            "c"{$newAsset.TECH_AREA = "Boundary Security"}
            "d"{$newAsset.TECH_AREA = "CDS Admin Review"}
            "e"{$newAsset.TECH_AREA = "CDS Technical Review"}
            "f"{$newAsset.TECH_AREA = "Database Review"}
            "g"{$newAsset.TECH_AREA = "Domain Name System (DNS)"}
            "h"{$newAsset.TECH_AREA = "Exchange Server"}
            "i"{$newAsset.TECH_AREA = "Host Based System Security (HBSS)"}
            "j"{$newAsset.TECH_AREA = "Internal Network"}
            "k"{$newAsset.TECH_AREA = "Mobility"}
            "l"{$newAsset.TECH_AREA = "Releasable Networks (REL)"}
            "m"{$newAsset.TECH_AREA = "Traditional Security"}
            "n"{$newAsset.TECH_AREA = "UNIX OS"}
            "o"{$newAsset.TECH_AREA = "VVOIP Review"}
            "p"{$newAsset.TECH_AREA = "Web Review"}
            "q"{$newAsset.TECH_AREA = "Windows OS"}
            "r"{$newAsset.TECH_AREA = "Other Review"}
            default{$newAsset.TECH_AREA = ""}
        }
        #set them to upper case for the lolz...
        $newAsset.HOST_NAME = $newAsset.HOST_NAME.ToUpper()
        $newAsset.HOST_IP = $newAsset.HOST_IP.ToUpper()
        $newAsset.HOST_MAC = $newAsset.HOST_MAC.ToUpper()
        $newAsset.HOST_FQDN = $newAsset.HOST_FQDN.ToUpper()

        Clear-Host
        Write-Host ""
        Write-Host "HOST_NAME:  " $newAsset.HOST_NAME
        Write-Host "HOST_IP:    " $newAsset.HOST_IP
        Write-Host "HOST_MAC:   " $newAsset.HOST_MAC
        Write-Host "HOST_FQDN:  " $newAsset.HOST_FQDN
        Write-Host "Asset Type: " $newAsset.ASSET_TYPE
        Write-Host "Role:       " $newAsset.ROLE
        Write-Host "Comment:    " $newAsset.TARGET_COMMENT
        Write-Host "TECH_AREA:  " $newAsset.TECH_AREA
        Write-Host ""
        
        $selection = Read-Host "Is this correct (y/n) (Default = y)"
        if($selection -ne "n"){
            if($this.Assets.HOST_NAME -contains $newAsset.HOST_NAME){
                Write-Error -Message "Asset already exists"
            }
            else{
                $this.Assets.Add($newAsset)
            }
        }



    }
    [void] ImportXML ([string]$PathToAssetList){
        if(Test-Path -Path $PathToAssetList){
            $this.importedAssets = Import-Clixml -Path $PathToAssetList
            $this.Assets = @()
            ForEach($tempAsset in $this.importedAssets){
                $this.AddAsset($tempAsset.ROLE,$tempAsset.ASSET_TYPE,$tempAsset.HOST_NAME,$tempAsset.HOST_IP,$tempAsset.HOST_MAC,$tempAsset.HOST_FQDN,$tempAsset.TARGET_COMMENT,$tempAsset.TECH_AREA)
                foreach($tempSTIG in $tempAsset.STIGS){
                    $this.Assets[-1].AddSTIG($tempSTIG.stigid,$tempSTIG.TECH_AREA,$tempSTIG.WEB_OR_DATABASE,$tempSTIG.WEB_DB_SITE,$tempSTIG.WEB_DB_INSTANCE)
                }
                if($tempAsset.Inactive){
                    $this.Assets[-1].Inactive = $true
                }
            }
        }
        else{
            Clear-Host
            Write-Host "Asset List was not found at " $PathToAssetList
            pause
        }
    
    }
    [void] ExportXML (){
        $PathToSave = $PWD.ToString() + "\AssetList.xml"
        $this.Assets | Export-Clixml -Path $PathToSave    
        Clear-Host
        Write-Host "Asset List Saved to " $PathToSave
        #pause
    }
    [void] purgeAssetList(){
        [string]$randomNumber = Get-Random -Minimum 1000 -Maximum 9999
        Clear-Host
        Write-Host "Purge will remove all Assets and STIG associations from memory.  It will not affect the saved Asset List (unless you save the empty list)"
        Write-Host "Confirm code:  " $randomNumber
        Write-host ""
        $selection = Read-Host -Prompt "Enter the Confirm code above to continue with purge"
        if($selection -eq $randomNumber){
            $this.Assets = @()
            Write-Host "Asset List purged"
            pause
        }
        else{
            Write-Host "Asset list was NOT purged, returning to previous menu"
            pause
        }
    }
    [void] displayAssetList(){
        $this.Assets | Select-Object -Property * | Out-GridView
    }
    [void] EditAsset([System.Collections.ArrayList]$Templates){
        $msgResponse = Read-Host -Prompt "Enter the HOST_NAME" 
        $msgResponse = $msgResponse.ToUpper()
        if($this.Assets.HOST_NAME -contains $msgResponse){
            $lclIndex = $this.Assets.HOST_NAME.indexof($msgResponse)
            #2x check to make sure index isnt dorked up.

            if($msgResponse -eq $this.Assets[$lclIndex].HOST_NAME){
                $NotFinished = $true
                DO{
                    $this.DisplayAssetInfo($msgResponse)
                    Write-Host "[0] Add STIGs"
                    Write-Host "[9] Remove STIGs"
                    Write-Host "[z] Back"
                    Write-host ""
                    $menuSelection = Read-Host -Prompt "Which field would you like to change"
                    switch($menuSelection){
                        '0'{$this.AddSTIGtoAsset($lclIndex,$Templates)}
                        '1'{$newIP = Read-Host -Prompt "Enter new IP address" ; $this.Assets[$lclIndex].SetIP($newIP) }
                        '2'{$newMAC = Read-Host -Prompt "Enter new MAC address";$this.Assets[$lclIndex].SetMAC($newMAC)}
                        '3'{$newFQDN = Read-Host -Prompt "Enter new FQDN";$this.Assets[$lclIndex].SetFQDN($newFQDN)}
                        '4'{$newROLE = $this.PromptROLE(); $this.Assets[$lclIndex].SetROLE($newROLE)}
                        '5'{if($this.Assets[$lclIndex].ASSET_TYPE -eq "Non-Computing"){$this.Assets[$lclIndex].ASSET_TYPE = "Computing"}else{$this.Assets[$lclIndex].ASSET_TYPE = "Non-Computing"}}
                        '6'{$newTECHAREA = $this.PromptTECHAREA();$this.Assets[$lclIndex].SetTECHAREA($newTECHAREA)}
                        '7'{$newCOMMENT = Read-Host -Prompt "Enter a Target Comment";$this.Assets[$lclIndex].SetCOMMENT($newCOMMENT)}
                        '8'{$this.Assets[$lclIndex].FlipInactive()}
                        '9'{$this.RemoveSTIGFromAsset($lclIndex)}
                        'z'{$NotFinished = $false}
                        'q'{exit}
                        'Q'{exit}
                    }
            
                }
                WHILE($NotFinished)
                $this.ExportXML()
            }

        }
        else{
            Write-Error "Unable to locate asset"
        }
        
    }
    [string]PromptROLE(){
        $newROLE = ""
        Clear-Host
        Write-Host "[1]  No Role"
        Write-Host "[2]  Workstation"
        Write-Host "[3]  Member Server"
        Write-Host "[4]  Domain Contoller"
        Write-Host ""
        $menuSelection = Read-Host -prompt "Select a role (No Role)"
        switch ($menuSelection){
            '1'{$newROLE = ""}
            '2'{$newROLE = "Workstation"}
            '3'{$newROLE = "Member Server"}
            '4'{$newROLE = "Domain Controller"}
        }

        return $newROLE
    }
    [string]PromptTECHAREA(){
        $newTECHAREA = ""
        Clear-Host
        Write-Host "[a]  None"
        Write-Host "[b]  Application Review"
        Write-Host "[c]  Boundary Security"
        Write-Host "[d]  CDS Admin Review"
        Write-Host "[e]  CDS Technical Review"
        Write-Host "[f]  Database Review"
        Write-Host "[g]  Domain Name System (DNS)"
        Write-Host "[h]  Exchange Server"
        Write-Host "[i]  Host Based System Security (HBSS)"
        Write-Host "[j]  Internal Network"
        Write-Host "[k]  Mobility"
        Write-Host "[l]  Releasable Networks (REL)"
        Write-Host "[m]  Traditional Security"
        Write-Host "[n]  UNIX OS"
        Write-Host "[o]  VVOIP Review"
        Write-Host "[p]  Web Review"
        Write-Host "[q]  Windows OS"
        Write-Host "[r]  Other Review"
        Write-Host ""
        $menuSelection = Read-Host -Prompt "Select technology area [Default: None]"
        switch($menuSelection){
            'a'{$newTECHAREA = ""}
            'b'{$newTECHAREA = "Application Review"}
            'c'{$newTECHAREA = "Boundary Security"}
            'd'{$newTECHAREA = "CDS Admin Review"}
            'e'{$newTECHAREA = "CDS Technical Review"}
            'f'{$newTECHAREA = "Database Review"}
            'g'{$newTECHAREA = "Domain Name System (DNS)"}
            'h'{$newTECHAREA = "Exchange Server"}
            'i'{$newTECHAREA = "Host Based System Security (HBSS)"}
            'j'{$newTECHAREA = "Internal Network"}
            'k'{$newTECHAREA = "Mobility"}
            'l'{$newTECHAREA = "Releasable Networks (REL)"}
            'm'{$newTECHAREA = "Traditional Security"}
            'n'{$newTECHAREA = "UNIX OS"}
            'o'{$newTECHAREA = "VVOIP Review"}
            'p'{$newTECHAREA = "Web Review"}
            'q'{$newTECHAREA = "Windows OS"}
            'r'{$newTECHAREA = "Other Review"}
        }


        Return $newTECHAREA
    }
    [void]AddSTIGtoAsset([int]$lclIndex,[System.Collections.ArrayList]$Templates){
        Clear-Host

        $lclCounter = 0
        [STIG]$newSTIG = [STIG]::new()
        
        
        ForEach($template in $Templates){
            Write-Host "["$lclCounter.ToString()"]  " -NoNewline
            Write-Host $template.stigid
            $lclCounter++
        }
        Write-Host ""
        $menuSelection = Read-Host -Prompt "Which STIG?"
        [int]$intNumber = [convert]::ToInt32($menuSelection,10)
        if($intNumber -ge 0){
            $newSTIG.stigid = $Templates[$intNumber].stigid
            if($Templates.stigid -contains $newSTIG.stigid){
                $responseWEBorDB = Read-Host "Is the a WEB or DATABASE STIG? (y/n)"
                if($responseWEBorDB -eq "y"){
                    $newSTIG.WEB_OR_DATABASE = "true"
                }
                else{
                    $newSTIG.WEB_OR_DATABASE = "false"
                }
                if($newSTIG.WEB_OR_DATABASE -eq "true"){
                    $newSTIG.WEB_DB_INSTANCE = (Read-Host "Enter the name of the INSTANCE").ToUpper()
                    $newSTIG.WEB_DB_SITE = (Read-Host "Enter the name of the DATABASE or WEBSITE").ToUpper()
                }
                else{
                    $newSTIG.WEB_DB_INSTANCE = ""
                    $newSTIG.WEB_DB_SITE = ""
                }
                $newSTIG.GenerateUniqueID($this.Assets[$lclIndex].HOST_NAME)
                Write-Host "Adding " $newSTIG.uniqueID.ToUpper()
                $this.Assets[$lclIndex].AddSTIG($newSTIG.stigid,"",$newSTIG.WEB_OR_DATABASE,$newSTIG.WEB_DB_SITE,$newSTIG.WEB_DB_INSTANCE)

            }
        }
    }

    [void]RemoveSTIGFromAsset([int]$lclIndex){
        Clear-Host
        $lclCounter = 0
        ForEach($cStig in $this.Assets[$lclIndex].STIGs){
            Write-Host "[" $lclCounter "]   " -NoNewline
            Write-Host $cStig.uniqueid
            $lclCOunter++
        }
        $menuSelection = Read-Host "Select STIG to Remove"
        [int]$intNumber = [convert]::ToInt32($menuSelection,10)
        if($intNumber -ge 0){
            $uniqueIDtoRemove = ""
            $uniqueIDtoRemove = $this.Assets[$lclIndex].stigs[$intNumber].uniqueid
            $this.Assets[$lclIndex].RemoveSTIG($uniqueIDtoRemove)
        }
    }

    [void]DisplayAssetInfo($HOST_NAME){
        Clear-Host
        $lclIndex = $this.Assets.HOST_NAME.indexof($HOST_NAME)
        Write-Host "[ ]  HOST_NAME:     " $this.Assets[$lclIndex].HOST_NAME
        Write-Host "[1]  HOST_IP:       " $this.Assets[$lclIndex].HOST_IP
        Write-Host "[2]  HOST_MAC:      " $this.Assets[$lclIndex].HOST_MAC
        Write-Host "[3]  HOST_FQDN:     " $this.Assets[$lclIndex].HOST_FQDN
        Write-Host "[4]  ROLE:          " $this.Assets[$lclIndex].ROLE
        Write-Host "[5]  ASSET_TYPE:    " $this.Assets[$lclIndex].ASSET_TYPE
        Write-Host "[6]  TECH_AREA:     " $this.Assets[$lclIndex].TECH_AREA
        Write-Host "[7]  COMMENT:       " $this.Assets[$lclIndex].TARGET_COMMENT
        Write-Host "[8]  Inactive?:     " $this.Assets[$lclIndex].Inactive
        Write-Host ""
        Write-host ($this.Assets[$lclIndex].STIGS | Format-Table | Out-String).ToString()

    }
    [void] ImportAssetsCSV(){
        Clear-Host
        Write-Host "Import Assets from CSV"
        Write-Host "CSV must be Tab delimited, with the following headers"
        Write-Host "ROLE	ASSET_TYPE	HOST_NAME	HOST_IP	HOST_MAC	HOST_FQDN	TARGET_COMMENT	TECH_AREA	Inactive"
        Write-Host
        [string]$CSVPath = Read-Host -Prompt "Enter the path to the tab delimited CSV file"
        Write-Host $CSVPath
        if(Test-Path -Path $CSVPath){
            Write-Host "Path available, Importing"
            $CSVData = Import-Csv -Delimiter "`t" -Path $CSVPath
            foreach($line in $CSVData){
                if($this.Assets.HOST_NAME -contains $line.HOST_NAME.ToUpper()){
                    #Asset already in memory - Maybe update information?
                }
                else{
                    $this.AddAsset($line.ROLE,$line.ASSET_TYPE,$line.HOST_NAME,$line.HOST_IP,$line.HOST_MAC,$line.HOST_FQDN,$line.TARGET_COMMENT,$line.TECH_AREA)
                    if($line.Inactive.toupper() -eq "TRUE"){
                        $this.Assets[-1].Inactive = $true
                    }
                }
            }
        }
        else{
            Write-Host "Path not available.  Import Failed"
        }
        pause
    }
    [void] ImportSTIGtoASSETMapping(){
        Clear-Host
        Write-Host "Import STIG to ASSET Mapping CSV"
        Write-Host "CSV must be tab delimited, with the folling headers"
        Write-Host "HOST_NAME	STIGID	WEB_OR_DATABASE	WEB_DB_SITE	WEB_DB_INSTANCE	TECH_AREA"
        Write-Host ""
        [string]$CSVPath = Read-Host -Prompt "Enter the path to the tab delimited CSV file"
        Write-Host $CSVPath
        if(Test-Path -Path $CSVPath){
            Write-Host "Patch available, Importing"
            $CSVData = Import-Csv -Delimiter "`t" -Path $CSVPath
            foreach($line in $CSVData){
                if($this.Assets.HOST_NAME -contains $line.HOST_NAME.ToUpper()){
                    #Asset is in memory
                    $this.Assets[$this.Assets.HOST_NAME.IndexOf($line.HOST_NAME.ToUpper())].AddSTIG($line.STIGID,$line.TECH_AREA,$line.WEB_OR_DATABASE,$line.WEB_DB_SITE.toUpper(),$line.WEB_DB_INSTANCE.ToUpper())
                }
                else{
                    #Asset is not in memory
                    Write-Host "Asset doesn't exist - Unable to import" $line
                }
            }
        }
        else{
            Write-Host "Path not available.  Import Failed"
        }
        pause
    }

}

class stroll{
    [AssetList]$AL = [AssetList]::New()
    [System.Collections.ArrayList]$Templates = @()
    [System.Collections.ArrayList]$Checklists = @()
    [System.Object]$SecurityOverrides = @()
    [string]$PATHWorkingDirectory = ""
    [System.Collections.ArrayList] $scores = @()

    stroll(){
        $this.PATHWorkingDirectory = $PWD.ToString()
        IF(Test-Path($this.PATHWorkingDirectory + "\Templates")){}
        ELSE{mkdir -Path ($this.PATHWorkingDirectory + "\Templates")}

        if(Test-Path($This.PATHWorkingDirectory + "\STIGs")){}
        else{mkdir -Path ($this.PATHWorkingDirectory + "\STIGs")}

        if(Test-Path($this.PATHWorkingDirectory + "CURRENT")){}
        else{mkdir -Path ($this.PATHWorkingDirectory + "\CURRENT")}

        if(Test-Path($this.PATHWorkingDirectory + "IMPORTS")){}
        else{mkdir -Path ($this.PATHWorkingDirectory + "\IMPORTS")}

        if(Test-Path($this.PATHWorkingDirectory + "ARCHIVE")){}
        else{mkdir -Path ($this.PATHWorkingDirectory + "\ARCHIVE")}

        #$this.Load_AssetListJSON($this.PATHWorkingDirectory + "\AssetList.JSON")
        $this.Load_AssetList($this.PATHWorkingDirectory + "\AssetList.XML")
        $this.Load_Templates($this.PATHWorkingDirectory + "\Templates")
        $this.Load_SeverityOverrides($this.PATHWorkingDirectory + "\Severity_Overrides.csv")
        $this.Menu_MAIN()
    }
    stroll([switch]$MethodsOnly){}
    #region Loads
    [void] Load_AssetListJSON([string]$lclpath){
        $this.AL = [AssetList]::new()
        if(Test-Path -Path $lclpath){
            $this.AL.ImportJSON($lclPath)
        }
    }
    [void] Load_Templates([string]$lclPath){
        $this.Templates = @()
        if(Test-Path -path $lclPath){
            $templateFiles = Get-ChildItem -Path $lclPath -Include *.ckl -Recurse
            foreach($templateFile in $templateFiles){
                [Checklist]$newChecklist = [Checklist]::new($templateFile.FullName)
                $this.Templates.Add($newChecklist) | out-null
            }
        }
    }
    [void] Load_SeverityOverrides([string]$lclPath){
        if(Test-Path -Path $lclPath){
            $This.SecurityOverrides = Import-Csv -Path $lclPath
        }
    }
    [void] Load_AssetList([string]$lclpath){
        $this.AL = [AssetList]::new()
        if(Test-Path -Path $lclpath){
            $this.AL.ImportXML($lclpath)
            if($this.AL.Assets.Count -eq 0){
                Write-Error -Message "No assets were imported from the asset list or the asset is was found to be empty."
            }
        }
        else{
            Write-Error -Message "Invalid path to the Assets File."
        }
        
    }
    #endregion
    #region MenuSystem
    [void] Menu_Display([switch]$ShowTitle,[switch]$ClearScreen,[string]$MenuTitle,[string]$OptionA,[string]$OptionB,[string]$OptionC,[string]$OptionD,[string]$OptionE){
        if($ClearScreen){Clear-Host}
        if($ShowTitle){$this.Menu_Title()}

        Write-Host -ForegroundColor Yellow "---------- $MenuTitle ----------"
        Write-Host "`r`r"
        If($OptionA -ne ""){Write-Host "[1]  " $OptionA}
        If($OptionB -ne ""){Write-Host "[2]  " $OptionB}
        If($OptionC -ne ""){Write-Host "[3]  " $OptionC}
        If($OptionD -ne ""){Write-Host "[4]  " $OptionD}
        If($OptionE -ne ""){Write-Host "[5]  " $OptionE}
        Write-Host "`r"
        Write-Host -ForegroundColor Gray "[z]   Back"
        Write-Host -ForegroundColor Gray "[q]   Quit"
        Write-Host ""
        Write-Host -ForegroundColor Yellow "------------------------------"
        Write-Host ""
    }
    [void] Menu_Title(){
        Write-Host -ForegroundColor Red "
  ______________________________ ________   ____     ____     
 /   _____/\__    ___/\______   \\_      \ |    |   |    |    
 \_____  \   |    |    |       _/ /   |   \|    |   |    |    
 /       /   |    |    |    |   \/    |    \    |___|    |___ 
/_______/    |____|    |____|___/\_________/_______/\_______/

                                                v2.0.0.231231




"
        
    }
    [void] Menu_MAIN(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"Main Menu","STROLL","Import","Export","Edit","Tools")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.SanityCheck()}
                '2'{$this.Menu_IMPORT()}
                '3'{$this.Menu_EXPORT()}
                '4'{$this.Menu_EDIT()}
                '5'{$this.Menu_TOOL()}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "zz")
    }
    [void] Menu_IMPORT(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"IMPORT Menu","Import Assets","Import Checklists","Import STIG/Asset Mapping","","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.AL.ImportAssetsCSV();$this.al.ExportXML()}
                '2'{$this.Process_CKL_Imports()}
                '3'{$this.AL.ImportSTIGtoASSETMapping();$this.al.ExportXML()}
                '4'{}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_EXPORT(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"EXPORT Menu","Export Asset List","Export STIG/Asset Mapping","Export ALL VULNs","Export Severity Override Report","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{Clear-Host;$this.AL.displayAssetList()}
                '2'{Clear-Host;$this.AL.Assets | Select-Object -Property HOST_NAME -ExpandProperty STIGS | Out-GridView}
                '3'{Clear-Host;if($this.Checklists.Count -eq 0){$this.Inspect_Checklists($this.PATHWorkingDirectory + "\Current")};$this.Checklists | Select-Object -Property HOST_NAME,HOST_IP,HOST_MAC,HOST_FQDN,TARGET_COMMENT,TECH_AREA,ROLE,stigid,version,release,WEB_OR_DATABASE,WEB_DB_INSTANCE,WEB_DB_SITE -ExpandProperty VULNS | Export-CSV -Path ($this.PATHWorkingDirectory + "\VULNS.csv").ToString();Write-host "All Vulns were exported to " $this.PATHWorkingDirectory ; pause}
                '4'{if($this.Checklists.Count -eq 0){$this.Inspect_Checklists($this.PATHWorkingDirectory + "\Current")};$this.Checklists | Select-Object -Property HOST_NAME, stigid,tech_Area,fileinfo -ExpandProperty vulns | Where-Object {$_.CCRIOverride} | Select-Object -Property HOST_NAME,stigid,tech_area,fileinfo,vulnid,status,severity,ruleid | Out-GridView}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_EDIT(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"EDIT Menu","EDIT Asset List","EDIT Asset","","","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.Menu_EDIT_ASSETLIST()}
                '2'{$this.Menu_EDIT_ASSET()}
                '3'{}
                '4'{}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_TOOL(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"TOOLs Menu","CCRI Tools","Download STIGs","Create Templates","","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.Menu_TOOL_CCRI()}
                '2'{$this.DownloadSTIGS()}
                '3'{$this.CreateTemplates()}
                '4'{}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_EDIT_ASSETLIST(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"EDIT Asset List Menu","SAVE Asset List","PURGE Asset List","RELOAD Asset List","DISPLAY Asset List","LOAD from XML")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.al.ExportXML()}
                '2'{$this.al.purgeAssetList()}
                '3'{$this.Load_AssetList($this.PATHWorkingDirectory + "\AssetList.XML")}
                '4'{Clear-Host;$this.AL.displayAssetList()}
                '5'{Clear-Host;$PATH_toAL = Read-Host -Prompt "Enter path to Asset List";$this.AL.ImportXML($PATH_toAL)}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_EDIT_ASSET(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"EDIT Asset Menu","ADD Asset","MODIFY Asset","REMOVE Asset","","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.AL.ManualAddAsset()}
                '2'{$this.AL.EditAsset($this.Templates)}
                '3'{$HostToRemove = Read-Host -Prompt "Enter HOST_NAME of asset to remove"; $this.AL.RemoveAsset($HostToRemove);Remove-Variable HostToRemove}
                '4'{}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    [void] Menu_TOOL_CCRI(){
        $menuSelection = ""
        DO{
            $this.Menu_Display($true,$true,"CCRI Tools","CCRI Score","Inspect Other Checklist Location","","","")
            $menuSelection = Read-Host "Enter your selection"
            switch($menuSelection){
                '1'{$this.Inspect_Checklists($this.PATHWorkingDirectory + "\Current");$this.Score_CCRI();$this.Display_Scores();pause}
                '2'{$tempValue = Read-Host -Prompt "Enter path to checklists you would like to inspect";If(Test-Path -Path $tempValue){$this.Inspect_Checklists($tempValue)} }
                '3'{}
                '4'{}
                '5'{}
                'q'{exit}
                'Q'{exit}
            }
        }
        until($menuSelection -eq "z")
    }
    #endregion

    [void] DownloadSTIGS(){
        $PathToSTIGFolder = $This.PATHWorkingDirectory + "\STIGS"
        if(Test-Path $PathToSTIGFolder){}
        ELSE{mkdir -Path $PathToSTIGFolder}
        Clear-Host
        Write-Host "Downloading STIGS from public.cyber.mil"
        Get-STIG -DestinationPath $PathToSTIGFolder -STIGID ALL 
    }
    [void] CreateTemplates(){
        $PathToSTIGFolder = $this.PATHWorkingDirectory + "\STIGS"
        $PathToTemplateFolder = $this.PATHWorkingDirectory + "\Templates\"
        $STIGZips = Get-ChildItem -Path $PathToSTIGFolder -Include "*.zip" -Recurse
        ForEach($STIG in $STIGZips){
            Write-Host $STIG.FullName
            New-TemplateCKL -SourceZIP $STIG.FullName -DestinationPath $PathToTemplateFolder 
        }
        $this.Load_Templates($this.PATHWorkingDirectory + "\Templates")
    }
    [void] SanityCheck(){
        Clear-Host
        $lclCounter = 0
        ForEach($lclAsset in $this.AL.Assets){
            $percentComplete = ($lclCounter / $this.AL.Assets.count) * 100
            Write-Progress -Activity "Strolling" -Status $lclAsset.HOST_NAME -PercentComplete $percentComplete -Id 100
            $lclAsset.Stroll($this.Templates)
            
            $lclCounter++
        }
        Write-Progress -Activity "Strolling" -Completed -Id 100
        $FoldersInCurrent = Get-ChildItem -Depth 1 -Directory -Path ($this.PATHWorkingDirectory +"\Current").ToString()
        Foreach($lclFolder in $FoldersInCurrent){
            If($this.AL.Assets.HOST_NAME -contains $lclFolder.Name){
                #Folder is linked to an asset
            }
            else{
                $DestinationPath = $this.PATHWorkingDirectory + "\archive\" + $lclFolder.name
                Compress-Archive -Path $lclFolder.fullname -DestinationPath $DestinationPath -CompressionLevel Optimal 
                Remove-Item -Path $lclFolder.fullname -Recurse

            }
        }


        pause
    }
    [void] Process_CKL_Imports(){
        Clear-Host
        [string]$PATHImports = $this.PATHWorkingDirectory + "\Imports"
        $FILECKLs = Get-ChildItem -Path $PATHImports -Include *.ckl -Recurse
        $lclCounter = 0
        ForEach($FILECkl in $FILECKLs){
            $lclCounter++
            $percentComplete = ($lclCounter / $FILECKLs.Count) * 100
            Write-Progress -Activity "Importing Checklists" -Status $FILECkl.Name -PercentComplete $percentComplete
            [Checklist]$importChecklist = [Checklist]::new($FILECKl.FullName.ToString())
            If($importChecklist.HOST_NAME -eq ""){
                Write-Error -Message "Checklist missing a host name"
            }
            ElseIf($importChecklist.xml.CHECKLIST.STIGS.iSTIG.Count -gt 1){
                $NoErrors = $true 
                For($lclIndex = 0; $lclIndex -lt $importChecklist.xml.CHECKLIST.STIGS.iSTIG.Count;$lclIndex++){
                    $duplicateImportXML = $importChecklist.xml.Clone()
                    $iSTIG = $duplicateImportXML.CHECKLIST.STIGS.iSTIG[$lclIndex]
                    ForEach($lclISTIG in $duplicateImportXML.CHECKLIST.STIGS.iSTIG){
                        if($iSTIG -eq $lclISTIG){
                            #Do nothing, because we want to keep this one
                        }
                        else{
                            $duplicateImportXML.CHECKLIST.STIGS.RemoveChild($lclISTIG)
                        }
                    }
                    #Now,  the XML should only contain a single checklist
                    if($duplicateImportXML.CHECKLIST.STIGS.iSTIG.Count -gt 1 -or $duplicateImportXML.CHECKLIST.STIGS.iSTIG.Count -eq 0){
                        
                    }
                    else{
                        [Checklist]$SingleCKL=[Checklist]::new($duplicateImportXML)
                        $PathToOriginalCkl = $this.Find_CKL_by_UID($SingleCKL.HOST_NAME,$SingleCKL.uniqueID)
                        if($PathToOriginalCkl -eq ""){
                            $NoErrors = $false
                            $errormsg = "Unable to locate an existing checklist for " + $SingleCKL.uniqueID
                            Write-Error -Message $errormsg
                            Remove-Variable errorMsg
                        }
                        else{
                            [Checklist]$originalChecklist = [Checklist]::new($PathToOriginalCkl)
                            $newChecklistXML = $this.Import_Checklist($false,$false,$SingleCKL.xml,$originalChecklist.xml)
                            $tempVR = "v" + $originalChecklist.version.ToString() + "r" + $originalChecklist.release.ToString()
                            $tempFileName = Resize-CKLFileName -HOST_NAME $originalChecklist.HOST_NAME -stigID $originalChecklist.stigid -DBSite $originalChecklist.WEB_DB_SITE -DBInstance $originalChecklist.WEB_DB_INSTANCE -vr $tempVR -fileExtension ".ckl" -MaxFileLength 75
                            $PATH_Save = $originalChecklist.FileInfo.Directory.FullName + "\" + $tempFileName
                            $newChecklistXML.save($PATH_Save)
                            Remove-Item -Path $originalChecklist.FileInfo.FullName
                            Remove-Variable newChecklistXML,tempVR,tempFileName,PATH_Save
                        }
                    }

                    Remove-Variable duplicateImportXML

                }
                if($NoErrors){Remove-Item -Path $importChecklist.FileInfo.FullName}
            }
            else{
                #Single Checklist in File
                #Find the correct checklist to import to.
                $PathToOriginalCkl = $this.Find_CKL_by_UID($importChecklist.HOST_NAME,$importChecklist.uniqueID)
                if($PathToOriginalCkl -eq ""){
                    $errorMsg = "Unable to locate an existing checklist for " + $importChecklist.uniqueID
                    Write-Error -Message $errorMsg
                    Remove-Variable errorMsg
                }
                else{
                    [Checklist]$originalChecklist = [Checklist]::new($PathToOriginalCkl)
                    $newChecklistXML = $this.Import_Checklist($false,$false,$importChecklist.xml,$originalChecklist.xml)
                    $tempVR = "v" + $originalChecklist.version.ToString() + "r" + $originalChecklist.release.ToString()
                    $tempFileName = Resize-CKLFileName -HOST_NAME $originalChecklist.HOST_NAME -stigID $originalChecklist.stigid -DBSite $originalChecklist.WEB_DB_SITE -DBInstance $originalChecklist.WEB_DB_INSTANCE -vr $tempVR -fileExtension ".ckl" -MaxFileLength 75
                    $PATH_Save = $originalChecklist.FileInfo.Directory.FullName + "\" + $tempFileName
                    $newChecklistXML.save($PATH_Save)

                    Remove-Item -Path $importChecklist.FileInfo.FullName
                    Remove-Item -Path $originalChecklist.FileInfo.FullName

                    Remove-Variable newChecklistXML,tempVR,tempFileName,PATH_Save
                }
                Remove-Variable PathToOriginalCkl
            }
        }
        Write-Progress -Activity "Importing Checklists" -Completed
        pause


    }
    [string] Find_CKL_by_UID([string]$HOST_NAME,[string]$UID){
        $PATHToCKL = ""
        $PATHTemp = $this.PATHWorkingDirectory + "\Current\" + $HOST_NAME
        if(Test-Path -Path $PATHTemp){
            #Path Exists
            $FILESExistingCkls = Get-ChildItem -Path $PATHTemp -Include *.ckl -Recurse
            foreach($FILECkl in $FILESExistingCkls){
                [Checklist]$newChecklist=[Checklist]::new($FILECkl.FullName)
                if($newChecklist.uniqueID -eq $UID){
                    $PATHToCKL = $newChecklist.FileInfo.FullName

                }
            }
        }
        return $PATHToCKL
    }
    [System.Xml.XmlNode] Import_Checklist([switch]$EnforceNotReviewed,[Switch]$AllowMatchOnVULID,[System.XML.XmlNode]$fromXML,[System.Xml.XmlNode]$toXML){
        [System.Collections.ArrayList]$FromVULNS = @()
        [System.Collections.ArrayList]$ToVULNS = @()
        [System.Xml.XmlNode]$outputXML = $toXML
        [System.Xml.XmlNode]$inputXML = $fromXML

        foreach($tmpXML in $inputXML.CHECKLIST.STIGS.iSTIG.VULN){
            [Vulnerability]$newVuln=[Vulnerability]::new($tmpXML)
            $FromVULNS.Add($newVuln) | Out-Null
        }
        Remove-Variable tmpXML
        Foreach($tmpXML in $outputXML.CHECKLIST.STIGS.iSTIG.VULN){
            [Vulnerability]$newVuln=[Vulnerability]::new($tmpXML)
            $ToVULNS.Add($newVuln) | Out-Null
        }
        Remove-Variable tmpXML
        foreach($VulIN in $FromVULNS){
            $CurrentTime = (Get-Date -Format yyyyMMdd-HHmmss).ToString()
            if($ToVULNS.RuleID.Contains($VulIN.RuleID)){
                #match on RuleID 
                $ruleIndex = $ToVULNS.RuleID.Indexof($VulIN.RuleID)
                if($outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STIG_DATA.ATTRIBUTE_DATA[$outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Rule_ID")] -eq $VulIN.RuleID){
                    if($EnforceNotReviewed.IsPresent){
                        #Force the Not Review Status!
                        if($VulIN.Status -ne $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS){
                            $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].FINDING_DETAILS = $VulIN.FindingDetails
                            $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS = $CurrentTime + ": Status change from " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS + " to " + $VulIN.Status + ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS
                            $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS = $VulIN.STATUS
                        }
                        else{
                            $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].FINDING_DETAILS = $VulIN.FindingDetails
                            $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS = $CurrentTime + ": Status remains " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS +  ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS                         
                        }
                    }
                    else{
                        #Do not force the Not Reviewed Status
                        if($VulIN.Status -eq "Not_Reviewed"){
                            #do nothing!!!!
                        }
                        else{
                            if($VulIN.Status -ne $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS){
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS = $CurrentTime + ": Status change from " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS + " to " + $VulIN.Status + ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS = $VulIN.STATUS
                            }
                            else{
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS = $CurrentTime + ": Status remains " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].STATUS +  ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$ruleIndex].COMMENTS                         
                            }
                        
                        }
                    }

                }
                else{
                    #This should never happen.
                    #Pause the import routine, as there is an issue with the code.  
                    Write-Error -Message "Unexpected Error is importing a checklist (Rule to Rule Match issue)"
                    pause
                }
                Remove-Variable ruleIndex
            }
            ElseIf($ToVULNS.VulnID.Contains($VulIN.VulnID)){
                #matched on Vuln ID
                $VulIDIndex = $ToVULNS.VulnID.Indexof($VulIN.VulnID)
                if($outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STIG_DATA.ATTRIBUTE_DATA[$outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Vuln_Num")] -eq $VulIN.VulnID){
                    if($AllowMatchOnVULID.IsPresent){
                        #Force matching on VUL ID - This will cause problems in the future...
                        if($EnforceNotReviewed.IsPresent){
                            #Match by Vul, enforce NR status
                            if($VulIN.Status -ne $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS){
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS = $CurrentTime + ": Status change from " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS + " to " + $VulIN.Status + ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS = $VulIN.STATUS
                            }
                            else{
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS = $CurrentTime + ": Status remains " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS +  ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS
                            }
                        }
                        else{
                            #Match by VulID, Do not enforce NR Status
                            if($VulIN.Status -eq "Not_Reviewed"){
                                #Do Nothing!
                            }
                            else{
                                if($VulIN.Status -ne $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS){
                                    $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                    $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS = $CurrentTime + ": Status change from " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS + " to " + $VulIN.Status + ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS
                                    $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS = $VulIN.STATUS
                                }
                                else{
                                    $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].FINDING_DETAILS = $VulIN.FindingDetails
                                    $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS = $CurrentTime + ": Status remains " + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].STATUS +  ". `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS
                                    
                                }                                
                            }             
                        }
                    }
                    else{
                        #Do not match based on VulID.  This will still make a comment.
                        $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS = $CurrentTime + ": Matched by VULNID and not RULEID.  Imported status (" + $VulIN.Status + ") not applied. `r`n" + $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].COMMENTS
                        $outputXML.CHECKLIST.STIGS.iSTIG.VULN[$VulIDIndex].FINDING_DETAILS = "VULNID Import - Imported findings as follows. `r`n" + $VulIN.FindingDetails
                    }
                }
                else{
                    #this should never happen.
                    #pause the import routine, as there is an issue with the code.
                    Write-Error -Message "Unexpected Error importing a checklist (Vuln_num to Vuln_num issue)"
                }

            }
            else{
                #No matches
            }
        }
        return $outputXML
    }
    [void] Inspect_Checklists([string]$PathToChecklists){
        $this.Checklists = @()
        #$tempPath = $this.PATHWorkingDirectory + "\Current"
        $tempPath = $PathToChecklists
        $ListCKL = Get-ChildItem -Path $tempPath -Include *.ckl -Recurse
        $lclCounter = 0
        ForEach($fileCKL in $ListCKL){
            $percentComplete = ($lclCounter / $ListCKL.Count) *100
            Write-Progress -Activity "Inspecting Checklists" -Status $fileCKL.name -PercentComplete $percentComplete
            [Checklist]$newChecklist = [Checklist]::new($fileCKL.FullName)
            $newChecklist.AnalyzeVulns($this.SecurityOverrides)
            #$newChecklist.xml = [System.Xml.XmlNode]::new()
            $newChecklist.EmptyXML()
            $this.Checklists.Add($newChecklist) | Out-Null
            $lclCOunter++
        }
        Write-Progress -Activity "Inspecting Checklists" -Completed
        Clear-Host
        
        
    }
    [void] Score_CCRI(){
        #To Be Completed
    }
    [void] Display_Scores(){
        #To Be Completed
    }
}
#endregion

#region Functions
function Import-Checklist {
    <#
    .SYNOPSIS
        Copies checklist data (host information and/or finding results) from one Checklist File to another.
        
    .DESCRIPTION
        Can be used to upgrade checklists to later versions / releases.  Import-checklist will copy data from a one checklist file to another.
    
    .PARAMETER SourceCKL
        Path to the Source Checklist file (.ckl) that will be used within the import.

    .PARAMETER DestinationCKL
        Path to the destination Checklist file (.ckl) that will be used within the import.

    .PARAMETER MatchON
        Default - RuleID
        Sets how this function will perform matching/
        RuleID means findings will be matched by RULEID value (Most Accurate / Most Stringent)
        VulnID means findings will be matched by VULNID value (Least Accurate / Least Stringent)
        WARNING:  Matching by VULNID can and will generate Type I and Type II Errors (False Positive / False Negative), specifically when upgrading checklists.

    .PARAMETER IgnoreNR
        Sets how this function will handle Not Reviewed checks in the Source Checklist File.
        Any check that was not reviewed is treated like a transparency (Ignored).
        This means that a NR Status and data will not be copied over to the destination checklist.
        Helpful when you are provided a partially completed checklist.
        
    .PARAMETER DataSet
        Default - All
        Infoms this function what set of data should be copied from SOURCE to DESTINATION
        Finding - Will copy only findings over, leaving the Asset Information alone in the destination.
        Asset - Will copy only asset information over, leaving the finding information alone in the destination
        All - Will copy both asset and finding information to destination    
    
    .EXAMPLE
        Import-Checklist -SourceCKL "C:\Temp\Source.ckl" -DestinationCKL "C:\Temp\Destination.ckl" -IgnoreNR

    #>
    param (
        [Parameter(Mandatory)]
        [string]$SourceCKL,
        [Parameter(Mandatory)]
        [string]$DestinationCKL,
        [PSDefaultValue(Help='RULEID')]
        [ValidateSet("RULEID","VULNID")]
        [string]$MatchOn = "RULEID",
        [switch]$IgnoreNR,
        [PSDefaultValue(Help='ALL')]
        [ValidateSet("ALL","ASSET","FINDING")]
        [string]$DataSet = "ALL"
    )
    
    [Checklist]$sCKL = [Checklist]::new($SourceCKL)
    [Checklist]$dCKL = [Checklist]::new($DestinationCKL)
    
    if(($DataSet -eq "ASSET") -or ($DataSet -eq "ALL")){
        $dCKL.ROLE = $sCKL.ROLE
        $dCKL.AssetType = $sCKL.AssetType
        $dCKL.HOST_NAME = $sCKL.HOST_NAME 
        $dCKL.HOST_IP = $sCKL.HOST_IP
        $dCKL.HOST_MAC = $sCKL.HOST_MAC
        $dCKL.HOST_FQDN = $sCKL.HOST_FQDN
        $dCKL.TARGET_COMMENT = $sCKL.TARGET_COMMENT
        $dCKL.TECH_AREA = $sCKL.TECH_AREA
        $dCKL.WEB_OR_DATABASE = $sCKL.WEB_OR_DATABASE
        $dCKL.WEB_DB_SITE = $sCKL.WEB_DB_SITE
        $dCKL.WEB_DB_INSTANCE = $sCKL.WEB_DB_INSTANCE
        $dckl.SetAssetInfo()
    }

    if(($DataSet -eq "FINDING") -or ($DataSet -eq "ALL")){
        $sCKL.AnalyzeVulns()
        $dCKL.AnalyzeVulns()
        foreach($sVuln in $sCKL.VULNS){
            if($dCKL.VULNS.VulnID -contains $sVuln.VulnID){
                $vulnIndex = $dCKL.VULNS.VulnID.IndexOf($sVuln.VulnID)
                if($dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.ATTRIBUTE_DATA[$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Vuln_Num") -eq $sVuln.VulnID]){
                    #2x checking the index.
                    if(($MatchOn -eq "VULNID") -or ($dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.ATTRIBUTE_DATA[$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Rule_ID") -eq $sVuln.RuleID])){
                        if($IgnoreNR.IsPresent -and $sVuln.Status -eq "Not_Reviewed"){
                            #SKIP!  
                        }
                        else{
                            $dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STATUS = $sVuln.STATUS
                            $dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].FINDING_DETAILS = $sVuln.FindingDetails
                            $dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].COMMENTS = $sVuln.Comments
                        }
                    }
                }

                Remove-Variable vulnIndex
            }
        }
    }

    $dCKL.xml.Save($DestinationCKL)
}

function Import-SCCXCCDF {
    <#
    .SYNOPSIS
        Imports SCC Tool XCCDF results into checklist.
        
    .DESCRIPTION
        
    
    .PARAMETER SourceXCCDF
        Path to the Source SCC XCCDF file (*_XCCDF-Results*.xml) that will be used within the import.

    .PARAMETER DestinationCKL
        Path to the destination Checklist file (.ckl) that will be used within the import.

    .PARAMETER MatchON
        Default - RuleID
        Sets how this function will perform matching/
        RuleID means findings will be matched by RULEID value (Most Accurate / Most Stringent)
        VulnID means findings will be matched by VULNID value (Least Accurate / Least Stringent)
        WARNING:  Matching by VULNID can and will generate Type I and Type II Errors (False Positive / False Negative), specifically when upgrading checklists.

    .PARAMETER FindingDetails
		Default - Basic
		Sets the amount of data to be placed in the Finding Details field.  Full will greatly increase the size of the checklist.
		Basic - [Tool]:  Result.  Example  SCC: Failed
		Full - Entire Benchmark.TestResult.RuleResult.Message.Text (Very Long)
        
    .PARAMETER DataSet
        Default - Finding
        Infoms this function what set of data should be copied from SOURCE to DESTINATION
        Finding - Will copy only findings over, leaving the Asset Information alone in the destination.
        Asset - Will copy only asset information over, leaving the finding information alone in the destination
        All - Will copy both asset and finding information to destination    
    
    .EXAMPLE
        Import-SCCXCCDF -SourceXCCDF "C:\Temp\Source.xml" -DestinationCKL "C:\Temp\Destination.ckl" -MatchOn VULNID -FindingDetails Full -DataSet ALL

    #>
    param (
        [Parameter(Mandatory)]
        [string]$SourceXCCDF,
        [Parameter(Mandatory)]
        [string]$DestinationCKL,
        [PSDefaultValue(Help='RULEID')]
        [ValidateSet("RULEID","VULNID")]
        [string]$MatchOn = "RULEID",
        [PSDefaultValue(Help='Basic')]
        [ValidateSet("Basic","Full")]     
		[string]$FindingDetails = "Basic",
        [PSDefaultValue(Help='FINDING')]
        [ValidateSet("ALL","ASSET","FINDING")]
        [string]$DataSet = "FINDING"
    )
    
    [SCCXCCDF]$sXCCDF = [SCCXCCDF]::new($SourceXCCDF)
    [Checklist]$dCKL = [Checklist]::new($DestinationCKL)
    
    if(($DataSet -eq "ASSET") -or ($DataSet -eq "ALL")){
        $dCKL.HOST_NAME = $sXCCDF.HOST_NAME 
        $dCKL.HOST_IP = $sXCCDF.HOST_IP
        $dCKL.HOST_MAC = $sXCCDF.HOST_MAC
        $dCKL.HOST_FQDN = $sXCCDF.HOST_FQDN
        $dCKL.SetHOSTNAME()
        $dCKL.SetIP()
        $dckl.SetMAC()
        $dCKL.SetFQDN()
        
    }

    if(($DataSet -eq "FINDING") -or ($DataSet -eq "ALL")){
        $sXCCDF.AnalyzeVulns()
        $dCKL.AnalyzeVulns()
        foreach($sVuln in $sXCCDF.VULNS){
            if($dCKL.VULNS.VulnID -contains $sVuln.VulnID){
                $vulnIndex = $dCKL.VULNS.VulnID.IndexOf($sVuln.VulnID)
                if($dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.ATTRIBUTE_DATA[$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Vuln_Num") -eq $sVuln.VulnID]){
                    #2x checking the index.
                    if(($MatchOn -eq "VULNID") -or ($dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.ATTRIBUTE_DATA[$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STIG_DATA.VULN_ATTRIBUTE.IndexOf("Rule_ID") -eq $sVuln.RuleID])){
                        if(($sVuln.Status -eq "NotAFinding") -or ($sVuln.Status -eq "Open") -or ($sVuln.Status -eq "Not_Applicable") ){
                            $dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].STATUS = $sVuln.STATUS
							if($FindingDetails -eq "Basic"){
								$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].FINDING_DETAILS = "SCC Result: " + $sVuln.Status
							}
							elseif($FindingDetails -eq "Full"){
								$dCKL.xml.CHECKLIST.STIGS.iSTIG.VULN[$vulnIndex].FINDING_DETAILS = $sVuln.FindingDetails
							}
                            
                            
                        }
                    }
                }

                Remove-Variable vulnIndex
            }
        }
    }

    $dCKL.xml.Save($DestinationCKL)
}

function Get-STIG {
    <#
    .SYNOPSIS
        Downloads the selected STIG from public.cyber.mil and places the zip file in the provided location
        
    .DESCRIPTION
        Hunting and pecking cyber.mil for a specific STIG is a pain.  This function will download 1 or all STIGs based on your input.
    
    .PARAMETER STIGID
        Currently forces ALL STIGS.  This will be tricky as some STIG IDs are included in a collection, but their names have nothing to due with the file name.
        Need to work on this one.  Maybe a fuzzy match?
    
    .PARAMETER DestinationPath
        Location to place the downloaded STIG
    
    .EXAMPLE
        Get-STIG -Destination "C:\Temp\STIGs\" -STIGID "ALL"

    #>
    param (
        [Parameter(Mandatory)]
        [string]$DestinationPath,
        [PSDefaultValue(Help='ALL')]
        [ValidateSet("ALL")]
        [string]$STIGID = "ALL"
    )
    $Global:ProgressPreference = 'SilentlyContinue'
    if(Test-Path $DestinationPath){
        #Path is good,  Pull CyberMIL links to STIGs
        $CyberMIL = Invoke-WebRequest -Uri "https://public.cyber.mil/stigs/downloads/"
        If(($CyberMIL.Links | Where-Object {$_.href -like "*STIG.zip"}).count -gt 0){
            #STIGs are available to download.
            if($STIGID -eq "ALL"){
                #Download all STIGs
                ForEach($STIGLink in ($CyberMIL.Links | Where-Object {$_.href -like "*STIG.zip"}).href ){
                    $tempDestinationPath = $DestinationPath
                    if($tempDestinationPath[-1] -eq "\"){
                        $tempDestinationPath = $tempDestinationPath + ($STIGLink -replace ".*./","")
                    }
                    else{
                        $tempDestinationPath = $tempDestinationPath + "\" + ($STIGLink -replace ".*./","")
                    }
                    Write-Output $tempDestinationPath
                    Invoke-WebRequest -Uri $STIGLink -OutFile $tempDestinationPath 
                    Remove-Variable tempDestinationPath
                }
                ForEach($SRGLink in ($CyberMIL.Links | Where-Object {$_.href -like "*SRG.zip"}).href ){
                    $tempDestinationPath = $DestinationPath
                    if($tempDestinationPath[-1] -eq "\"){
                        $tempDestinationPath = $tempDestinationPath + ($SRGLink -replace ".*./","")
                    }
                    else{
                        $tempDestinationPath = $tempDestinationPath + "\" + ($SRGLink -replace ".*./","")
                    }
                    Write-Output $tempDestinationPath
                    Invoke-WebRequest -Uri $SRGLink -OutFile $tempDestinationPath 
                    Remove-Variable tempDestinationPath
                }
            }
            else{
                #Download just the selected STIG
            }
        }
        else {
            Write-Error -Message "Unable to access public.Cyber.Mil"
        }

    }
    else {
        Write-Error -Message "Provided path does not exist."
    }
    $Global:ProgressPreference = 'Continue'
    
}

function New-TemplateCKL {
<#
    .SYNOPSIS
        Creates a CKL File based on a provided STIG ZIP
        
    .DESCRIPTION
        
    
    .PARAMETER SourceZIP
        Path to the STIG ZIP
    
    .PARAMETER DestinationPath
        Path (Directory) to place the template CKL

    
    .EXAMPLE
        New-TemplateCKL -SourceZIP C:\Temp\SourceZIP.zip -DestinationPath C:\Temp

    #>
    param (
        [Parameter(Mandatory)]
        [string]$SourceZIP,
        [Parameter(Mandatory)]
        [string]$DestinationPath
    )
    #TO DO - Clean this up.. Most of the XML Writer code blocks can be put into a loop.  Did not do this initially because i wanted to make sure i was pulling the correct information from the XML.
    #Spot checked - The below code makes almost identical checklists as STIG Viewer, except for the STIG UUID and STIG viewer will place empty LEGACY id fields.
    
    #check paths
    
    #open STIG ZIP
    [TechAreas]$TechnologyAreas = [TechAreas]::new()
    Add-Type -Assembly  "System.IO.Compression.Filesystem"
    $stigZIP = [Io.Compression.zipfile]::OpenRead($SourceZIP)
    $stigFiles = $stigZIP.Entries | Where-Object {$_.Name -like "*xccdf.xml"}
    ForEach($xccdf in $stigFiles){
        $xccdfStream = $xccdf.Open()
        $reader = New-Object IO.StreamReader($xccdfStream)
        $text = $reader.ReadToEnd()
        $XMLxccdf = (Select-Xml -Content $text -XPath /).node
        

        $lclSTIGID = $XMLxccdf.Benchmark.id
        $lclSTIGVersion = $XMLxccdf.Benchmark.version
        $lclSTIGRelease = $XMLxccdf.Benchmark.'plain-text'.'#text'[$XMLxccdf.Benchmark.'plain-text'.id.IndexOf("release-info")]
        $lclSTIGRelease = $lclSTIGRelease -replace " Benchmark.*",""
        $lclSTIGRelease = $lclSTIGRelease -replace "Release: ",""
        if($lclSTIGRelease -eq "R"){
            $lclSTIGRelease = $XMLxccdf.Benchmark.'plain-text'.'#text'
            $lclSTIGRelease = $lclSTIGRelease -replace " Benchmark.*",""
            $lclSTIGRelease = $lclSTIGRelease -replace "Release: ",""
        }
        $CKLFileName = $lclSTIGID + "_V" + $lclSTIGVersion + "R" + $lclSTIGRelease + ".ckl"
        $outFile = $DestinationPath + "\" + $CKLFileName
        $lclSTIGUUID = (New-Guid).Guid
        
        #Start XML Writer
        $SettingsXML = [System.Xml.XmlWriterSettings]::new()
        $SettingsXML.Indent = $true
        $SettingsXML.NewLineChars = "`r`n"
        $SettingsXML.IndentChars = "`t"

        $WriterXML = [System.Xml.XmlWriter]::Create($outFile,$SettingsXML)
        #$WriterXML = [System.Xml.XmlWriter]::new()
        $WriterXML.WriteComment("DISA STIG Viewer :: 2.17")
        $WriterXML.WriteStartElement("CHECKLIST")
        #region ASSET
            $WriterXML.WriteStartElement("ASSET")
                $WriterXML.WriteStartElement("ROLE") 
                    $WriterXML.WriteString("None")
                $WriterXML.WriteEndElement() #role
                $WriterXML.WriteStartElement("ASSET_TYPE") 
                    $WriterXML.WriteString("Computing")
                $WriterXML.WriteEndElement() #ASSET_TYPE
                $WriterXML.WriteStartElement("MARKING") 
                    $WriterXML.WriteString("CUI")
                $WriterXML.WriteEndElement() #MARKING
                $WriterXML.WriteStartElement("HOST_NAME") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #HOST_NAME
                $WriterXML.WriteStartElement("HOST_IP") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #HOST_IP
                $WriterXML.WriteStartElement("HOST_MAC") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #HOST_MAC
                $WriterXML.WriteStartElement("HOST_FQDN") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #HOST_FQDN
                $WriterXML.WriteStartElement("TARGET_COMMENT") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #TARGET_COMMENT
                $WriterXML.WriteStartElement("TECH_AREA")
                    if($TechnologyAreas.mapping.stigid.contains($lclSTIGID)){
                        $WriterXML.WriteString($TechnologyAreas.mapping.TECH_AREA[$TechnologyAreas.mapping.stigid.IndexOf($lclSTIGID)])
                    } 
                    else{
                        $WriterXML.WriteString("")
                    }
                $WriterXML.WriteEndElement() #TECH_AREA
                $WriterXML.WriteStartElement("TARGET_KEY") 
                    $WriterXML.WriteString($XMLxccdf.Benchmark.Group[0].Rule.reference.identifier)
                $WriterXML.WriteEndElement() #TARGET_KEY
                $WriterXML.WriteStartElement("WEB_OR_DATABASE")
                    if($TechnologyAreas.mapping.stigid.contains($lclSTIGID)){
                        if(($TechnologyAreas.mapping.TECH_AREA[$TechnologyAreas.mapping.stigid.IndexOf($lclSTIGID)] -eq "Web Review") -or ($TechnologyAreas.mapping.TECH_AREA[$TechnologyAreas.mapping.stigid.IndexOf($lclSTIGID)] -eq "Database Review")){
                            $WriterXML.WriteString("true")
                        }
                        else{
                            $WriterXML.WriteString("false")
                        }
                    }
                    else {
                        $WriterXML.WriteString("false")
                    }
                $WriterXML.WriteEndElement() #WEB_OR_DATABASE
                $WriterXML.WriteStartElement("WEB_DB_SITE") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #WEB_DB_SITE
                $WriterXML.WriteStartElement("WEB_DB_INSTANCE") 
                    $WriterXML.WriteString("")
                $WriterXML.WriteEndElement() #WEB_DB_INSTANCE
            $WriterXML.WriteEndElement() #asset
        #endregion
            $WriterXML.WriteStartElement("STIGS")
                $WriterXML.WriteStartElement("iSTIG")
                    #region STIG INFO
                    $WriterXML.WriteStartElement("STIG_INFO")
                        #version    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("version")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($lclSTIGVersion)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #classification    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("classification")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString("UNCLASSIFIED")
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #customname    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("customname")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString("")
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #stigid    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("stigid")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($lclSTIGID)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #description    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("description")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($XMLXccdf.Benchmark.description)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #filename    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("filename")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($xccdf.Name)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #releaseinfo    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("releaseinfo")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($XMLxccdf.Benchmark.'plain-text'.'#text'[$XMLxccdf.Benchmark.'plain-text'.id.IndexOf("release-info")])
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #title    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("title")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($XMLXccdf.Benchmark.title)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #uuid    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("uuid")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($lclSTIGUUID)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #notice    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("notice")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString("terms-of-use")
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        #source    
                        $WriterXML.WriteStartElement("SI_DATA")
                        $WriterXML.WriteStartElement("SID_NAME")
                                $WriterXML.WriteString("source")
                            $WriterXML.WriteEndElement() #SID_NAME
                            $WriterXML.WriteStartElement("SID_DATA")
                                $WriterXML.WriteString($XMLXccdf.Benchmark.reference.source)
                            $WriterXML.WriteEndElement() #SID_DATA
                        $WriterXML.WriteEndElement() #SI_DATA
                        
                    $WriterXML.WriteEndElement() #STIG_INFO
                    #endregion
                    #region VULNS
                    ForEach($lclVULN in $XMLxccdf.Benchmark.Group){
                        $WriterXML.WriteStartElement("VULN")
                            #Vuln_Num
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Vuln_Num")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.id)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Severity
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Severity")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.rule.severity)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Group_Title
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Group_Title")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.title)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Rule_ID
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Rule_ID")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.rule.id)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Rule_Ver
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Rule_Ver")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.rule.version)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Rule_Title
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Rule_Title")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.rule.title)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Vuln_Discuss
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Vuln_Discuss")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(($lclVuln.Rule.description -replace ".*<VulnDiscussion>",""  -replace "</VulnDiscussion>.*",""))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #IA_Controls
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("IA_Controls")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<IAControls\>(.*)\<\/IAControls",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Check_Content
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Check_Content")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.Rule.check.'check-content')
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Fix_Text
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Fix_Text")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.Rule.fixtext.'#text')
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #False_Positives
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("False_Positives")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<FalsePositives\>(.*)\<\/FalsePositives",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #False_Negatives
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("False_Negatives")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<FalseNegatives\>(.*)\<\/FalseNegatives",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Documentable
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Documentable")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<Documentable\>(.*)\<\/Documentable",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Mitigations
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Mitigations")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<Mitigations\>(.*)\<\/Mitigations",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Potential_Impact
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Potential_Impact")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<PotentialImpacts\>(.*)\<\/PotentialImpacts",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Third_Party_Tools
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Third_Party_Tools")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<ThirdPartyTools\>(.*)\<\/ThirdPartyTools",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Mitigation_Control
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Mitigation_Control")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<MitigationControl\>(.*)\<\/MitigationControl",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Responsibility
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Responsibility")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<Responsibility\>(.*)\<\/Responsibility",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Security_Override_Guidance
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Security_Override_Guidance")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString(([regex]::Match($lclVuln.Rule.description.ToString(),"\<SeverityOverrideGuidance\>(.*)\<\/SeverityOverrideGuidance",[System.Text.RegularExpressions.RegexOptions]::Multiline).Groups[1].Value))
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Check_Content_Ref
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Check_Content_Ref")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.Rule.check.'check-content-ref'.name)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Weight
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Weight")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclVuln.Rule.weight)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Class
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("Class")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString("Unclass")
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #STIGRef
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("STIGRef")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($XMLXccdf.Benchmark.title + " :: Version " + $lclSTIGVersion + ", " + $XMLxccdf.Benchmark.'plain-text'.'#text'[$XMLxccdf.Benchmark.'plain-text'.id.IndexOf("release-info")] )
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #TargetKey
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("TargetKey")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($XMLxccdf.Benchmark.Group[0].Rule.reference.identifier)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #STIG_UUID
                            $WriterXML.WriteStartElement("STIG_DATA")
                                $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                    $WriterXML.WriteString("STIG_UUID")
                                $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                    $WriterXML.WriteString($lclSTIGUUID)
                                $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                            $WriterXML.WriteEndElement() #STIG_DATA
                            #Legacy Loop!
                            ForEach($legacy in ($lclVULN.Rule.ident | Where-Object {$_.system -eq "http://cyber.mil/legacy"}).'#text'){
                                #LEGACY_ID
                                $WriterXML.WriteStartElement("STIG_DATA")
                                    $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                        $WriterXML.WriteString("LEGACY_ID")
                                    $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                    $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                        $WriterXML.WriteString($legacy)
                                    $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                                $WriterXML.WriteEndElement() #STIG_DATA
                            }

                            #CCI Loop
                            ForEach($CCI in ($lclVULN.Rule.ident | Where-Object {$_.system -eq "http://cyber.mil/CCI"}).'#text'){
                                #CCI_REF
                                $WriterXML.WriteStartElement("STIG_DATA")
                                    $WriterXML.WriteStartElement("VULN_ATTRIBUTE")
                                        $WriterXML.WriteString("CCI_REF")
                                    $WriterXML.WriteEndElement() #VULN_ATTRIBUTE
                                    $WriterXML.WriteStartElement("ATTRIBUTE_DATA")
                                        $WriterXML.WriteString($CCI)
                                    $WriterXML.WriteEndElement() #ATTRIBUTE_DATA
                                $WriterXML.WriteEndElement() #STIG_DATA
                            }

                            #status
                            $WriterXML.WriteStartElement("STATUS")
                                $WriterXML.WriteString("Not_Reviewed")
                            $WriterXML.WriteEndElement() #STATUS
                            #FINDING_DETAILS
                            $WriterXML.WriteStartElement("FINDING_DETAILS")
                                $WriterXML.WriteString("")
                            $WriterXML.WriteEndElement() #FINDING_DETAILS
                            #COMMENTS
                            $WriterXML.WriteStartElement("COMMENTS")
                                $WriterXML.WriteString("")
                            $WriterXML.WriteEndElement() #COMMENTS
                            #SEVERITY_OVERRIDE
                            $WriterXML.WriteStartElement("SEVERITY_OVERRIDE")
                                $WriterXML.WriteString("")
                            $WriterXML.WriteEndElement() #SEVERITY_OVERRIDE
                            #SEVERITY_JUSTIFICATION
                            $WriterXML.WriteStartElement("SEVERITY_JUSTIFICATION")
                                $WriterXML.WriteString("")
                            $WriterXML.WriteEndElement() #SEVERITY_JUSTIFICATION
                        $WriterXML.WriteEndElement() #VULN
                    }
                    #endregion
                $WriterXML.WriteEndElement() #iSTIG
            $WriterXML.WriteEndElement()#STIGS
        $WriterXML.WriteEndElement() #checklist
        #end write
        $WriterXML.flush()
        $WriterXML.close()


        $reader.Close()
        $xccdfstream.close()
    }
    $stigZIP.Dispose()



}

function Resize-CKLFileName {
    <#
    .SYNOPSIS
        CKL File names can get rather large.  This function will reduce the length of the CKL file name to a given character size.
        
    .DESCRIPTION
        
    
    .PARAMETER HOST_NAME
        HostName of the associated checklist.  This field should never be resized
    
    .PARAMETER STIGID
        STIGID of the associated checklist.  This field should be the last one to be resized

    .PARAMETEr DBSite
        Website or Database name of the associated checklist. 
    
    .PARAMETER DBInstance
        Database Instance Name of the associated checklist

    .PARAMETER vr
        Version and Release in "V#R#" format of the associated checklist.  Should never be resized.

    .PARAMETER fileExtension
        File extenstion in the ".ckl" format.  
    
    .PARAMETER MaxFileLength
        Force the maximum length of the file name.  Never set this below 70.

    .EXAMPLE
        Resize-CKLFileName -HOST_NAME "WorkstationABC" -stigID "MS_Windows_11_STIG" -vr "V1R3" -fileExtension ".ckl" -MaxFileLength 80

    #>
    param (
        [Parameter(Mandatory)]
        [string]$HOST_NAME,
        [Parameter(Mandatory)]
        [string]$stigid,
        [string]$DBSite,
        [string]$DBInstance,
        [Parameter(Mandatory)]
        [string]$vr,
        [Parameter(Mandatory)]
        [string]$fileExtension,
        [Parameter(Mandatory)]
        [int]$MaxFileLength
    )
    $MaxFileLength = 70
    [string]$newFileName = ""
    [string]$dtg = (Get-date -Format yyyyMMdd-HHmmssfff).ToString()
    $newFileName = $HOST_NAME + "_" + $stigID + "_" + $vr + "_" + $DBInstance + "_" + $DBSite + "_" + $dtg + $fileExtension
    $newFileName = $newFileName.Replace(" ","")

    if($newFileName.Length -gt $MaxFileLength){
        #Preferred shorten
        if($DBInstance.Length -ge 10){
            $DBInstance = $DBInstance.Substring(0,9)
        }
        if($DBSite.Length -ge 10){
            $DBSite = $DBSite.Substring(0,9)
        }
        $newFileName = $HOST_NAME + "_" + $stigID + "_" + $vr + "_" + $DBInstance + "_" + $DBSite + "_" + $dtg + $fileExtension
    }


    if($newFileName.Length -gt $MaxFileLength){
        Do{
            if($DBSite.Length -gt 5){
                $DBSite = $DBSite.Substring(0,$DBSite.Length -  1)
            }
            elseif($DBInstance.Length -gt 5){
                $DBInstance = $DBInstance.Substring(0,$DBInstance.Length -1)                
            }
            elseif($stigID.Length -gt 10){
                $stigID = $stigID.Substring(0,$stigID.Length -1)
            }
            elseif($HOST_NAME.Length -gt 10){
                $HOST_NAME = $HOST_NAME.Substring(0,$HOST_NAME.Length -1)
            }
            

            $newFileName = $HOST_NAME + "_" + $stigID + "_" + $vr + "_" + $DBInstance + "_" + $DBSite + "_" + $dtg + $fileExtension                
        }
        until($newFileName.Length -le $MaxFileLength)
    }



    return $newFileName
}

function Export-VulnerabilityList {
<#
    .SYNOPSIS
        Reads all checklists inside a given directoy, and exports the vulnerability information to a given filetype.
        
    .DESCRIPTION
        
    
    .PARAMETER Path
        Location of the checklists that will be reviewed.
    
    .PARAMETEr ExportType
        Select CSV JSON or XLSX formats 
    
    .PARAMETER Detail
        Select the level of detail 

    .PARAMETER Destination
        Export VULN information to this location

    .EXAMPLE
        Export-VulnerabilityList -path C:\Path\to\review -ExportType CSV -Detail BASIC -Destination C:\path\to\export\file.csv 

    #>
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [PSDefaultValue(Help='CSV')]
        [ValidateSet("CSV","JSON")]
        [string]$ExportType = "CSV",
        [PSDefaultValue(Help='BASIC')]
        [ValidateSet("BASIC","MIN","MAX")]
        [string]$Detail = "BASIC",
        [Parameter(Mandatory)]
        [string]$Destination
    )
    [System.Collections.ArrayList]$Checklists = @()

    $cklFiles = Get-ChildItem -Path $Path -Include *.ckl -Recurse
    If($cklFiles.count -gt 0){
        ForEach($CklFile in $CklFiles){
            [Checklist]$newCKL = [Checklist]::new($CklFile.fullname)
            $newCKL.AnalyzeVulns()
            $newCKL.xml.RemoveAll()
            $Checklists.Add($newCKL) | Out-Null
        }
        $VULNS = ""
        if($Detail -eq "BASIC"){
            $VULNS = $Checklists | Select-Object -Property stigid,version,release,FileInfo.Name, uniqueID,HOST_NAME,HOST_IP,HOST_MAC,HOST_FQDN,WEB_DB_INSTANCE,WEB_DB_SITE,TECH_AREA,ROLE,TARGET_COMMENT,AssetType -ExpandProperty VULNS | Select-Object -Property stigid,version,release,FileInfo.Name, uniqueID,HOST_NAME,HOST_IP,HOST_MAC,HOST_FQDN,WEB_DB_INSTANCE,WEB_DB_SITE,TECH_AREA,ROLE,TARGET_COMMENT,AssetType,VulnID,Status,Severity,RuleID,CCRIOverride,KIoRSection,KIoRSubSection,points
        }
        elseif ($Detail -eq "MAX") {
            $VULNS = $Checklists | Select-Object -Property stigid,version,release,FileInfo.Name, uniqueID,HOST_NAME,HOST_IP,HOST_MAC,HOST_FQDN,WEB_DB_INSTANCE,WEB_DB_SITE,TECH_AREA,ROLE,TARGET_COMMENT,AssetType -ExpandProperty VULNS 
        }
        elseif ($Detail -eq "MIN") {
            $VULNS = $Checklists | Select-Object -Property stigid,host_name,tech_area -ExpandProperty VULNS | Select-Object -Property stigid,host_name,tech_area,VulnID,Status,Severity
        }

        IF($ExportType -eq "CSV"){
            $VULNS | Export-Csv -Path $Destination -NoTypeInformation -NoClobber 
        }
        ElseIF($ExportType -eq "JSON"){
            ConvertTo-Json -InputObject $VULNS >> $Destination
        }
        ElseIf($ExportType -eq "XLSX"){
            #NOPE!!!  Not today!
        }
        #$vulns | Out-GridView
    }
    else{
        #Do Nothing
    }
}

function Invoke-STROLL{
    [stroll]$newStroll = [stroll]::new()
}
#endregion
