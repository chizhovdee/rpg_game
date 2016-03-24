Spine.Model.detect = (callback)->
  for r in @records
    if callback(r)
      return r.clone()