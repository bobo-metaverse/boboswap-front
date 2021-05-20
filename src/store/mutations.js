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
			let assets = list.assets;
			list.pairs.map((item1) => {
				const FilerArry = BASEJS.filerArry(item1.peerTokens,assets);
				FilerArry.map((item) => {
					item.baseTokenAddr = item1.baseTokenAddr;
					item.baseTokenName = item1.baseTokenName;
					item.coingecko_currency = item1.coingecko_currency;
					//
					//24H涨跌幅
					let url =
						API.getRiseFall +
						"vs_currency=" +
						item.coingecko_currency +
						"&ids=" +
						item.coingeckoId;
					axios.get(url).then((res) => {
						// console.log(res.data[0].high_24h);
						item.high24h = res.data[0].price_change_percentage_24h.toFixed(2);
						state.hangqing.push(item);
						//aa.push(item);
					});
				});
			});
		})
	}
}
export default mutations