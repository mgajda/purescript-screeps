-- | Corresponds to the Screeps API [RoomObject](http://support.screeps.com/hc/en-us/articles/208435305-RoomObject)
module Screeps.RoomObject where

import Prelude

import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Either (Either(..))
import Data.Function (on)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (try)
import Effect.Unsafe (unsafePerformEffect)
import Screeps.FFI (unsafeField, toMaybe, NullOrUndefined, instanceOf)
import Screeps.Id (class HasId, decodeJsonWithId, encodeJsonWithId, validate)
import Screeps.Names (RoomName)
import Screeps.RoomPosition.Type (RoomPosition)
import Unsafe.Coerce (unsafeCoerce)

foreign import data Room :: Type

instance showRoom :: Show Room where
  show = show <<< name

instance eqRoom :: Eq Room where
  eq = eq `on` name

-- | Any `RoomObject` with a location, and room containing it. 
class RoomObject a

name :: Room -> RoomName
name = unsafeField "name"

instance encodeJson :: EncodeJson Room where
  encodeJson = encodeJson <<< name

foreign import lookupRoom :: RoomName -> Effect (NullOrUndefined Room)

instance decodeJson :: DecodeJson Room where
  decodeJson json = do
    roomNam <- decodeJson json
    case unsafePerformEffect $ try $ map toMaybe $ lookupRoom roomNam of
      Left err ->
        Left $ "Cannot access the room: " <> show roomNam
          <> " because of: "
          <> show err
      Right (Nothing) -> Left $ "Cannot access room: " <> show roomNam
      Right (Just r) -> Right r

foreign import data AnyRoomObject :: Type

instance anyRoomObject :: RoomObject AnyRoomObject

instance anyRoomObjectHasId :: HasId AnyRoomObject where
  validate = instanceOf "RoomObject"

instance encodeAnyRoomObject :: EncodeJson AnyRoomObject where
  encodeJson = encodeJsonWithId

instance decodeAnyRoomObject :: DecodeJson AnyRoomObject where
  decodeJson = decodeJsonWithId

room :: forall a. RoomObject a => a -> Room
room = unsafeField "room"

pos :: forall a. RoomObject a => a -> RoomPosition
pos = unsafeField "pos"

asAnyRoomObject ::
  forall ro.
  RoomObject ro =>
  ro -> AnyRoomObject
asAnyRoomObject = unsafeCoerce

fromAnyRoomObject ::
  forall ro.
  HasId ro =>
  AnyRoomObject ->
  Maybe ro
fromAnyRoomObject ro =
  if validate o then
    Just o
  else
    Nothing
  where
  o = unsafeCoerce ro
