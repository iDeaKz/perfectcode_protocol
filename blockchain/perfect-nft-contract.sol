```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * PerfectCode NFT Contract v1.0
 * ERC-721 implementation for 10kb perfect code
 */
contract PerfectCodeNFT is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;
    
    // Perfect code storage
    mapping(uint256 => string) private _generatedCode;
    mapping(uint256 => uint256) private _codeSize;
    mapping(uint256 => address) private _generators;
    mapping(uint256 => uint256) private _generationTimestamp;
    mapping(uint256 => bytes32) private _codeHash;
    
    // Perfect 10kb tracking
    mapping(uint256 => bool) private _isPerfectTenKB;
    uint256 private _perfectTenKBCount;
    
    // Events
    event CodeGenerated(
        uint256 indexed tokenId, 
        address indexed generator, 
        uint256 codeSize,
        bytes32 codeHash
    );
    
    event PerfectTenKB(
        uint256 indexed tokenId, 
        address indexed generator,
        uint256 exactSize
    );
    
    event QualityAssessed(
        uint256 indexed tokenId,
        uint256 qualityScore,
        string[] metrics
    );

    constructor() ERC721("PerfectCode", "PCODE") {}
    
    /**
     * Generate and mint perfect code NFT
     */
    function generateAndMint(
        address to,
        string memory generatedCode,
        uint256 codeSize,
        bytes32 codeHash
    ) external nonReentrant returns (uint256) {
        require(codeSize > 0 && codeSize <= 10240, "Invalid code size");
        require(bytes(generatedCode).length > 0, "Empty code");
        require(to != address(0), "Invalid recipient");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(to, tokenId);
        
        // Store code metadata
        _generatedCode[tokenId] = generatedCode;
        _codeSize[tokenId] = codeSize;
        _generators[tokenId] = msg.sender;
        _generationTimestamp[tokenId] = block.timestamp;
        _codeHash[tokenId] = codeHash;
        
        // Check for perfect 10kb
        if (codeSize == 10240) {
            _isPerfectTenKB[tokenId] = true;
            _perfectTenKBCount++;
            emit PerfectTenKB(tokenId, msg.sender, codeSize);
        }
        
        emit CodeGenerated(tokenId, msg.sender, codeSize, codeHash);
        
        return tokenId;
    }
    
    /**
     * Get code size for token
     */
    function getCodeSize(uint256 tokenId) external view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return _codeSize[tokenId];
    }
    
    /**
     * Check if code is perfect 10kb
     */
    function isPerfectTenKB(uint256 tokenId) external view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return _isPerfectTenKB[tokenId];
    }
    
    /**
     * Get total perfect 10kb count
     */
    function getPerfectTenKBCount() external view returns (uint256) {
        return _perfectTenKBCount;
    }
    
    /**
     * Get code generator
     */
    function getGenerator(uint256 tokenId) external view returns (address) {
        require(_exists(tokenId), "Token does not exist");
        return _generators[tokenId];
    }
    
    /**
     * Get code hash for verification
     */
    function getCodeHash(uint256 tokenId) external view returns (bytes32) {
        require(_exists(tokenId), "Token does not exist");
        return _codeHash[tokenId];
    }
    
    /**
     * Calculate code quality score
     */
    function assessQuality(uint256 tokenId) external view returns (uint256 score) {
        require(_exists(tokenId), "Token does not exist");
        
        uint256 size = _codeSize[tokenId];
        
        // Base score from size efficiency
        if (size == 10240) {
            score = 100; // Perfect 10kb gets perfect score
        } else {
            uint256 deviation = size > 10240 ? size - 10240 : 10240 - size;
            score = deviation < 1024 ? 100 - (deviation * 100 / 1024) : 0;
        }
        
        return score;
    }
    
    /**
     * Bulk mint for batch generation
     */
    function batchMint(
        address[] memory recipients,
        string[] memory codes,
        uint256[] memory sizes,
        bytes32[] memory hashes
    ) external nonReentrant returns (uint256[] memory tokenIds) {
        require(recipients.length == codes.length, "Array length mismatch");
        require(codes.length == sizes.length, "Array length mismatch");
        require(sizes.length == hashes.length, "Array length mismatch");
        require(recipients.length <= 50, "Batch size too large");
        
        tokenIds = new uint256[](recipients.length);
        
        for (uint256 i = 0; i < recipients.length; i++) {
            tokenIds[i] = this.generateAndMint(
                recipients[i],
                codes[i],
                sizes[i],
                hashes[i]
            );
        }
        
        return tokenIds;
    }
    
    /**
     * Emergency pause mechanism
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
}
```