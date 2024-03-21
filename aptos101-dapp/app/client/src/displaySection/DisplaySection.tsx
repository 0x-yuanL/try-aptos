import React, { useEffect } from "react";
import { usePet } from "../hooks/usePet";

/**
 * 因为时间原因，暂时只实现了 PET NFT 链上数据的宠物名字展示
 * 但相关其他 API 调用接口调用差不多已经写好。
 *   - mint_pet
 *   -
 */
export const NFTDisplaySection = ({ address }: { address: string }) => {
  const [pet] = usePet(address);

  const PetName = () => <h3>Pet Name: {pet.petName}</h3>;

  return <PetName />;
};
