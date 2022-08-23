import React, {Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBirdz from '../abis/KryptoBirdz.json';
import {MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn} from 'mdb-react-ui-kit';
import './App.css';

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockChainData();
    }

    //first up is to detect ethereum provider
    loadWeb3 = async() => {
        const provider = await detectEthereumProvider();

        //modern browers
        //if there is provider then
        //lets log that it's working and access the window form doc to set the web3 to the provider

        if(provider) {
            console.log('Ethereum wallet is connected');
            window.web3 = new Web3(provider);
        } else {
            //no ethereu provider
            console.log('no ethereum wallet detected');
        }
    };

    loadBlockChainData = async()=>{
        let web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({account:accounts[0]});

        const networkId = await web3.eth.net.getId();

        const networkData = KryptoBirdz.networks[networkId];

        if(networkData) {
            const abi = KryptoBirdz.abi;
            const address = networkData.address;
            const contract = await new web3.eth.Contract(abi, address);
            this.setState({contract:contract});

            const totalsupply = await contract.methods.totalSupply().call({from:this.state.account});
            console.log('totalsupply',totalsupply);
            this.setState({totalsupply:totalsupply});

            //load krptobirds
            
            for(let i=0; i < totalsupply; i++) {
                let krptoBird =  await contract.methods.kryptoBirds(i).call();
                this.setState({
                    krptoBirds:[...this.state.krptoBirds, krptoBird]
                })
            }
        } else {
            window.alert('Smart Contract is not deployed');
        }
    }

    mint = (krptoBird) => {
       this.state.contract.methods.mint(krptoBird).send({from:this.state.account})
        .once('receipt', (receipt) => {
            this.setState({
                krptoBirds:[...this.state.krptoBirds, krptoBird]
            })
        });
    }

    constructor(props) {
        super(props);
        this.state = {
            account : '',
            contract:null,
            totalSupply:0,
            krptoBirds:[]
        }
    }

    render () {
        return(
            <div className="container-filled">
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                <div className='navbar-brand col-sm-3 col-md-3 mr-0' style={{color:'white'}}>
                            Krypto Birdz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className='navbar-nav px-3'>
                    <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main' className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto' style={{opacity:'0.8'}}>
                                <h1 style={{color:'black'}}> KryptoBirdz - NFT Marketplace</h1>
                                <form onSubmit={(event)=>{
                                    event.preventDefault()
                                    const kryptoBird = this.kryptoBird.value
                                    this.mint(kryptoBird)}}>
                                    <input type='text' placeholder='Add a file location' className='form-control mb-1' ref={(input)=>this.kryptoBird = input}/>
                                    <input style={{margin:'6px'}} type='submit' className='btn btn-primary btn-black' value='MINT'/>
                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>
                    <div className='row textCenter'>
                        {this.state.krptoBirds.map((krptoBird, key)=>{
                            return(<div>
                                <div>
                                    <MDBCard className="token img" style={{maxWidth:'22rem'}}>
                                    <MDBCardImage src={krptoBird} position='top' height='250rem' style={{marginRight:'4px'}}/>
                                    <MDBCardBody>
                                    <MDBCardTitle>KrptoBirds</MDBCardTitle>
                                    <MDBCardText>The KrptoBirds are 20 uniquely generated KBirdz from the cyberpunk cloud galaxy Mystopia! The is only one of each bird and each bird can be owned by a single person on the Ethereum blockchain.</MDBCardText>
                                    <MDBBtn href={krptoBird}>Download</MDBBtn>
                                    </MDBCardBody>
                                    </MDBCard>
                                </div>
                            </div>)
                        })}
                    </div>
                </div>
            </div>
        )
    }
}

export default App;
