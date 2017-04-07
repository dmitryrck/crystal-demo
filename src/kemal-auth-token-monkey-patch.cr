class Kemal::AuthToken
  def call(context)
    # sign_in
    if context.request.path == @path
      if context.params.body["email"]? && context.params.body["password"]?
        uh = @sign_in.call(context.params.body["email"].as(String), context.params.body["password"].as(String))
        if uh["id"]?
          # that means it's ok
          token = JWT.encode(uh, @secret_key, @algorithm)
          context.response << {token: token}.to_json
          return context
        end
      end
    end

    # auth
    if context.request.headers["X-Token"]?
      token = context.request.headers["X-Token"]
      payload, header = JWT.decode(token, @secret_key, @algorithm)
      payload
      context.current_user = @load_user.call(payload)
    end
    call_next context
  end
end

# Diff
#% diff lib/kemal-auth-token/src/kemal-auth/auth_token.cr changed-line.cr
#37c37
#<         uh = @sign_in.call(context.params.body["email"], context.params.body["password"])
#---
#>         uh = @sign_in.call(context.params.body["email"].as(String), context.params.body["password"].as(String))
#
