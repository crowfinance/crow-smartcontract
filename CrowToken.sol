pragma solidity 0.6.12;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrowToken is ERC20("Crow Token", "CROW"), Ownable {
    
    //@notice overrides transfer function to meet tokenomics of CROW - burn rate
    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        uint256 rateAmount = 1; //burn 1% 18.00-06.00 UTC time
        uint256 getHour = (block.timestamp / 60 / 60) % 24; //get hour in utc time
        if(getHour >= 6 && getHour < 18){ //burn 3% 06.00-18.00 UTC time
            rateAmount = 3;
        }
        uint256 burnAmount = amount.mul(rateAmount).div(100); // every transfer burnt
        uint256 sendAmount = amount.sub(burnAmount); // transfer sent to recipient
        require(amount == sendAmount + burnAmount, "Burn value invalid");
        super._burn(sender, burnAmount);
        super._transfer(sender, recipient, sendAmount);
        amount = sendAmount;
          
    }    

    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (FarmContract).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
    // burn logic
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

}
