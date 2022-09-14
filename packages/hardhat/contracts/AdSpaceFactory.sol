//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./ITablelandTables.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//import "./AdSpace.sol";

contract AdSpaceFactory {
    // contract for optimism-goerli right now


    address private constant TABLELANDCONTRACT =
        0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA;
    ITablelandTables private _tableland;

    uint256 private _adspacetableid;
    string private _adSpaceTable;

    uint256 private _campaigntableid;
    string private _campaignTable;

    uint256 private _dealtableid;
    string private _dealTable;


    constructor(address tablelandAddress) {
        _tableland = ITablelandTables(tablelandAddress);

        _adspacetableid = _createTable("CREATE TABLE AdSpaces (adspace_id INTEGER PRIMARY KEY UNIQUE,name TEXT, website TEXT, verified INTEGER, status TEXT, owner TEXT, contract TEXT, asking_price INTEGER);");
        _adSpaceTable = string.concat("AdSpaces","_",Strings.toString(block.chainid),"_",Strings.toString(_adspacetableid));

        _campaigntableid = _createTable("CREATE CAMPAIGN STATEMENT");
        _campaignTable = string.concat("Campaigns","_",Strings.toString(block.chainid),"_",Strings.toString(_adspacetableid));

        _dealtableid = _createTable("CREATE DEAL STATEMENT");
        _dealTable = string.concat("Deals","_",Strings.toString(block.chainid),"_",Strings.toString(_adspacetableid));
    }

    function createAdSpace(
        string memory _name,
        string memory _website,
        //string _symbol,
        string memory  _asking_price
        //uint256 _adspaceId,
        //address _adspaceOwner,
        //uint8 _numNFTs
    ) external payable /*returns (address)*/ {
        //AdSpace _adspace = new AdSpace(
        //    _name,
        //    _symbol,
        //    _adspaceId,
        //    _adspaceOwner,
        //    _numNFTs
        //);
        string memory sqlStatement = 
        string.concat(
        "INSERT INTO "
        ,_adSpaceTable
        ," (name,website,verified,status,owner,contract,asking_price) VALUES ("
        ,_name
        ,','
        ,_website
        ,','
        ,"0"
        ,','
        ,'Pending Verification'
        ,','
        //,AdSpace.address
        ,','
        ,_asking_price
        ,');'
        );
        
      
        _runSQL(_adspacetableid, sqlStatement);
        //return address(_adspace);
    }

    function _createTable(string memory statement)
        internal
        returns (uint256)
    {
        return _tableland.createTable(address(this), statement);
    }

    function runSQL(uint256 tableId, string memory statement)
        external
        payable
    {
        _runSQL(tableId, statement);
    }

    function _runSQL(uint256 tableId, string memory statement)
        internal
    {
        _tableland.runSQL(address(this), tableId, statement);
    }

    // onlyOwner
    function setController(uint256 tableId, address controller)
        external
    {
        _tableland.setController(address(this), tableId, controller);
    }

    // onlyOwner
    function lockController(uint256 tableId) external {
        _tableland.lockController(address(this), tableId);
    }

    // onlyOwner
    function setBaseURI(string memory baseURI) external {
        _tableland.setBaseURI(baseURI);
    }

    // onlyOwner
    function pause() external {
        _tableland.pause();
    }

    // onlyOwner
    function unpause() external {
        _tableland.unpause();
    }

    // getter
    function getController(uint256 tableId)
        external
        //override
        returns (address)
    {
        return _tableland.getController(tableId);
    }

    function getAdSpaceTableId() view external returns (uint256) {
        return _adspacetableid;
    }

    function getCampaignTableId() view external returns (uint256) {
        return _campaigntableid;
    }

    function getDealTableId() view external returns (uint256) {
        return _dealtableid;
    }

    function getAdSpaceTable() view external returns (string memory) {
        return _adSpaceTable;
    }

    function getCampaignTable() view external returns (string memory) {
        return _campaignTable;
    }

    function getDealTable() view external returns (string memory) {
        return _dealTable;
    }
}
