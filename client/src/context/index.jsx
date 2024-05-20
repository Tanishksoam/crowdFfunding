import React, { useContext, createContext } from "react";
import {
  useAddress,
  useContract,
  useContractWrite,
  useConnect,
  ThirdwebProvider,
} from "@thirdweb-dev/react";
import { ethers } from "ethers";

const StateContext = createContext();

export const StateProvider = ({ children }) => {
  const { contract } = useContract(
    "0x96bA45A594C9F946e8Cd918fC124BA2c876C3929"
  );
  const { mutateAsync: createContract } = useContractWrite(
    contract,
    "createCampaign"
  );
  const address = useAddress();
  const connect = useConnect();

  const connectWallet = async () => {
    try {
      await connect("injected"); // Use "injected" to connect to MetaMask
      console.log("Connected to MetaMask");
    } catch (error) {
      console.error("Failed to connect wallet", error);
    }
  };

  const publishCampaign = async (form) => {
    try {
      const data = await createContract({
        args: [
          address,
          form.title,
          form.description,
          form.target,
          new Date(form.deadline).getTime(),
          form.image,
        ],
      });
      console.log(data);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <StateContext.Provider
      value={{ address, contract, connect, createCampaign: publishCampaign }}
    >
      {children}
    </StateContext.Provider>
  );
};

export const useStateContext = () => useContext(StateContext);
