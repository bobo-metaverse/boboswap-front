import * as TYPES from "./types";
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
	}
}
export default mutations