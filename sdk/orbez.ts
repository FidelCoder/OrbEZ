import { ethers } from "ethers";

export class OrbEZSDK {
  private walletContract: ethers.Contract;

  constructor(provider: ethers.Provider, walletAddress: string) {
    this.walletContract = new ethers.Contract(walletAddress, /* ABI */, provider);
  }

  async sendFunds(to: string, amount: bigint, currency: string) {
    await this.walletContract.sendFunds(to, amount, currency);
  }
}