import * as TYPES from "./types"
const actions = {
  changeSkin(vuex, v) {
    vuex.commit(TYPES.CHANGE_SKIN, v)
    
  },
  chageHeader(vuex, v) {
    vuex.commit(TYPES.CHANGE_HEADER, v)
	},
}
export default actions