// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { KromaMintableERC721 } from "./KromaMintableERC721.sol";
import { ISemver } from "./ISemver.sol";

/**
 * @title KromaMintableERC721Factory
 * @notice Factory contract for creating KromaMintableERC721 contracts.
 */
contract KromaMintableERC721Factory is ISemver {
    /**
     * @notice Address of the ERC721 bridge on this network.
     */
    address public immutable BRIDGE;

    /**
     * @notice Chain ID for the remote network.
     */
    uint256 public immutable REMOTE_CHAIN_ID;

    /**
     * @notice Tracks addresses created by this factory.
     */
    mapping(address => bool) public isKromaMintableERC721;

    /**
     * @notice Emitted whenever a new KromaMintableERC721 contract is created.
     *
     * @param localToken  Address of the token on the this domain.
     * @param remoteToken Address of the token on the remote domain.
     * @param deployer    Address of the initiator of the deployment
     */
    event KromaMintableERC721Created(
        address indexed localToken,
        address indexed remoteToken,
        address deployer
    );

    /**
     * @notice Semantic version.
     * @custom:semver 1.0.0
     */
    string public constant version = "1.0.0";

    /**
     * @notice Constructs the KromaMintableERC721Factory contract.
     *         The semver MUST be bumped any time that there is a change in
     *         the KromaMintableERC721 token contract since this contract
     *         is responsible for deploying KromaMintableERC721 contracts.
     *
     * @param _bridge Address of the ERC721 bridge on this network.
     * @param _remoteChainId Chain ID for the remote network.
     */
    constructor(address _bridge, uint256 _remoteChainId) {
        BRIDGE = _bridge;
        REMOTE_CHAIN_ID = _remoteChainId;
    }

    /**
     * @notice Creates an instance of the standard ERC721.
     *
     * @param _remoteToken Address of the corresponding token on the other domain.
     * @param _name        ERC721 name.
     * @param _symbol      ERC721 symbol.
     */
    function createKromaMintableERC721(
        address _remoteToken,
        string memory _name,
        string memory _symbol
    ) external returns (address) {
        require(
            _remoteToken != address(0),
            "KromaMintableERC721Factory: L1 token address cannot be address(0)"
        );

        address localToken = address(
            new KromaMintableERC721(BRIDGE, REMOTE_CHAIN_ID, _remoteToken, _name, _symbol)
        );

        isKromaMintableERC721[localToken] = true;
        emit KromaMintableERC721Created(localToken, _remoteToken, msg.sender);

        return localToken;
    }
}
