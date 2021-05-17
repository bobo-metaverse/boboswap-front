import state from "./state"

 const getters = {
	skin:(state,getters)=>{
		return state.skin
	 },
	 header:(state,getters)=>{
		return state.header
	 },
	 account:(state,getters) =>{
		return state.account
	 },
	 isConnected: (state, getters) => {
		return state.isConnected
	 },
	 chainId:(state, getters) => {
		return state.chainId
	 }
}
export default(getters)