import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter as Router } from "react-router-dom";
import { ChainId, ThirdwebProvider } from "@thirdweb-dev/react";
import "./index.css";

import App from "./App";
import { StateProvider } from "./context";

const root = ReactDOM.createRoot(document.getElementById("root"));

root.render(
  <ThirdwebProvider desiredChainId={ChainId.Sepolia}>
    <Router>
      <StateProvider>
        <App />
      </StateProvider>
    </Router>
  </ThirdwebProvider>
);
