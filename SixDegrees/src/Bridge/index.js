import { NativeModules, NativeEventEmitter } from 'react-native';
import { account, addRefer } from '../eos';

const { SCPDataBridge } = NativeModules;
const BridgeEvents = new NativeEventEmitter(SCPDataBridge);

BridgeEvents.addListener('getAccount', data => {
  SCPDataBridge.returnValue(data.execId, { success: true, message: account })
});

BridgeEvents.addListener('newRefer', async data => {
  const parameters = data.parameters;
  const result = await addRefer(parameters.author, parameters.caseId, parameters.referId);
  SCPDataBridge.returnValue(data.execId, {
    success: true,
    message: JSON.stringify({
      msg: 'Block.one is looking for a proficient C++ developers. If you know anybody who is interested, please let us know.',
      link: `${result.init}:${result.caseid}:${result.id}`,
    })
  });
});

BridgeEvents.addListener('giveReward', async data => {
  const parameters = data.parameters;
  const result = await giveReward(parameters.author, parameters.caseId, parameters.referId);
  SCPDataBridge.returnValue(data.execId, {
    success: true,
    message: 'You give back the rewards!',
  });
});

export default SCPDataBridge;
