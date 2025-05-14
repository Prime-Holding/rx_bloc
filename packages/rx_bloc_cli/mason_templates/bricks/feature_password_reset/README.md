# feature_password_reset

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A brick designed to bootstrap the integration of a robust Password Reset flow into your application. This feature enables users to reset their password using their email, with intuitive confirmation pages for each step.

<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/develop/packages/rx_bloc_cli/doc/assets/images/password_reset_request.png" alt="Feature Password Reset Request" width="200">
<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/develop/packages/rx_bloc_cli/doc/assets/images/password_reset_confirmation.png" alt="Feature Password Reset Email Confirmation" width="200">
<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/develop/packages/rx_bloc_cli/doc/assets/images/password_reset.png" alt="Feature Password Reset" width="200">
<img src="https://raw.githubusercontent.com/Prime-Holding/rx_bloc/refs/heads/develop/packages/rx_bloc_cli/doc/assets/images/password_reset_success.png" alt="Feature Password Reset Success" width="200">

## Features

- **Password Reset Request**: Allows users to request a password reset using their email.
- **Email Confirmation**: Lets the user open their email client & resend a new link. (contains mock links to be used for testing)
- **Password Change**: Allows users to change their password after opening the link.

## Authentication

This feature includes basic input validation and authentication infrastructure related to the password reset process. Users can reset their password using their email as credentials.

## Important Note

This brick is a bootstrap tool meant to make kickstarting a password reset flow faster. It includes only a basic example backend and does not actually send confirmation emails. It is expected that a "real" backend would handle these tasks in the future.

## API Contracts

For detailed API contracts and to better understand the flow, please refer to the [API Contracts](__brick__/docs/forgotten_pass_api_contracts.md) document.