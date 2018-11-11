import Eos from 'eosjs';

export const account = 'roseroserose';
// export const account = 'danisthebest';
// export const account = 'blockonehire';

const eos = Eos({
  httpEndpoint: 'http://jungle.cryptolions.io:18888',
  chainId: '038f4b0fc8ff18a4f0842a8f0564611f6e96e8535901dd45e43ac8691a1c4dca',
  keyProvider: [
    '5JuGuVv2J7GtFJjqU3j3XjgK2kCNYxrxutSRkjtBG1r5YK1RPdC', // blockonehire
    '5J7oKHkL3PcXnaTGVCW92Pn9JdmVGxR4AJU9Nc4WtuUh7VcooGP', // roseroserose
    '5KFzCiQJpwXpTAmHgXbWiGiqcJG3uAiHxf6JiPQN1gEebqn5JUW', // danisthebest
    '5JEuMQ9pYvukzWRkjcDGwQTb4ejCdg9jMs7XhiEYGY6nnXtx3Ur' // sixdegreesio
  ],
  // authorization: '@owner',
});

// blockonehire
// 5JuGuVv2J7GtFJjqU3j3XjgK2kCNYxrxutSRkjtBG1r5YK1RPdC
// EOS5LPJJnkkYQLEoA8ef8WWS6M2F9A7rKaam4my4bAqVggc4t5YMJ
//
//
// roseroserose
// 5J7oKHkL3PcXnaTGVCW92Pn9JdmVGxR4AJU9Nc4WtuUh7VcooGP
// EOS8dWogCU4DRfGsHrA2uBaaPGECXg87Pu1b7uJNUrSR29x5EZsNS
//
//
// danisthebest
// 5KFzCiQJpwXpTAmHgXbWiGiqcJG3uAiHxf6JiPQN1gEebqn5JUW
// EOS6dWMJcVPTu47XJwvK1HWXLW3t1gbUMVghX61vzGHWaVhaSVB23
//
// sixdegreesio
// 5JEuMQ9pYvukzWRkjcDGwQTb4ejCdg9jMs7XhiEYGY6nnXtx3Ur
// EOS7vtNQfzCjcGwpgfZpQejNaWNJ66b9Yvv72GHuy3iNaiDTsC2ve

export async function getBalance() {
  const result = await eos.getAccount(account);
  return Number(result.core_liquid_balance.split(' ')[0]);
}

export function newCase(amount, memo) {
  return eos.transaction({
    actions: [
      {
        account: 'eosio.token',
        name: 'transfer',
        authorization: [{ actor: account, permission: 'active' }],
        data: {
          from: account,
          to: 'sixdegreesio',
          quantity: `${amount.toFixed(4)} EOS`,
          memo,
        },
      },
    ],
  });
}

export function deleteCase(id) {
  return eos.transaction({
    actions: [
      {
        account: 'sixdegreesio',
        name: 'cancel',
        authorization: [{ actor: account, permission: 'active' }],
        data: {
          account,
          id,
        },
      },
    ],
  });
}

export function getTableRow(table) {
  return eos.getTableRows({
    json: true,
    code: 'sixdegreesio',
    scope: account,
    table: 'cases',
    limit: '10',
  });
}

export async function giveReward(caseAuthor, caseId, id) {
  const result = await eos.transaction({
    actions: [
      {
        account: 'sixdegreesio',
        name: 'givereward',
        authorization: [{ actor: account, permission: 'active' }],
        data: {
          caseauthor: caseAuthor,
          caseid: caseId,
          id,
        },
      },
    ],
  });
}

export async function addRefer(caseAuthor, caseId, id) {
  const result = await eos.transaction({
    actions: [
      {
        account: 'sixdegreesio',
        name: 'addrefer',
        authorization: [{ actor: account, permission: 'active' }],
        data: {
          user: account,
          caseauthor: caseAuthor,
          caseid: caseId,
          id,
        },
      },
    ],
  });
  const rows = await eos.getTableRows({
    json: true,
    code: 'sixdegreesio',
    scope: 'sixdegreesio',
    table: 'referals',
    limit: 100,
  });
  return rows.rows.reverse()[0];
}

export default eos;
