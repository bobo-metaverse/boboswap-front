import * as TYPES from "./types"
const actions = {
  changeSkin(vuex, v) {
    vuex.commit(TYPES.CHANGE_SKIN, v)
    
  },
  chageHeader(vuex, v) {
    vuex.commit(TYPES.CHANGE_HEADER, v)
  },
  setAccount(vuex, v) {
    vuex.commit(TYPES.SET_ACCOUNT,v)
  },
  setIsConnected(vuex, v) {
    vuex.commit(TYPES.SET_ISCONNECTED,v)
  },
  setChainId(vuex, v) {
    vuex.commit(TYPES.SET_CHAINID,v)
  },
}
export default actions