import * as TYPES from "./types";
import * as API from "../assets/js/Common/API"
import axios from 'axios'
import * as BASEJS from '../assets/js/Common/base'
const mutations = {
  [TYPES.CHANGE_SKIN](state, v) {
		state.skin = v;
		localStorage.setItem("Skin", v);
	},
	[TYPES.CHANGE_HEADER](state, v) {
		state.header = v;
	},
	[TYPES.SET_ACCOUNT](state, v) {
		state.account = v;
	},
	[TYPES.SET_ISCONNECTED](state, v) {
		state.isConnected = v;
	},
	[TYPES.SET_CHAINID](state, v) {
		state.chainId = v;
	},
	[TYPES.GET_HANGQING](state, v) {
		let chainId = state.chainId.toString()
		axios.get(API.getQuotation).then((quotation) => {
			//console.log(quotation)
			const list = quotation.data[chainId];
			let assets = {};
			list.assets.map(asset => {
				assets[asset.address] = asset;
			})
			console.log('assets', assets)
			//list.pairs.map(async (pairBaseInfo) => {
				//const FilerArry = BASEJS.filerArry(item1.peerTokens,assets);
				//pairBaseInfo.peerTokens.map(async (peerAddr) => {
			for (var i = 0; i < list.pairs.length; i++) {
				const pairBaseInfo = list.pairs[i];
				for (var j = 0; j < pairBaseInfo.peerTokens.length; j++) {
					const peerAddr = pairBaseInfo.peerTokens[j];
					const pairInfo = JSON.parse(JSON.stringify(assets[peerAddr]));
					if (pairInfo == null) return;
					pairInfo.baseTokenAddr = pairBaseInfo.baseTokenAddr;
					pairInfo.baseTokenName = pairBaseInfo.baseTokenName;
					pairInfo.coingecko_currency = pairBaseInfo.coingecko_currency;
					console.log(pairInfo.symbol + '/' + pairInfo.baseTokenName);
					//
					//24H涨跌幅
					let url =
						API.getRiseFall +
						"vs_currency=" +
						pairInfo.coingecko_currency +
						"&ids=" +
						pairInfo.coingeckoId;
					axios.get(url).then((res) => {
						pairInfo.high24h = res.data[0].price_change_percentage_24h.toFixed(2);
						state.hangqing.push(pairInfo);
						console.log('>>>>' + pairInfo.symbol + '/' + pairInfo.baseTokenName);						
					});
				}
			}
			state.hangqing.map(hangqing => console.log(hangqing.symbol + '/' + hangqing.baseTokenName));
		});
			//});
		//})
	}
}
export default mutations